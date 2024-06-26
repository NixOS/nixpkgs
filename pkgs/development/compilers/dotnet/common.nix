# TODO: switch to stdenvNoCC
{ stdenv
, lib
, writeText
, testers
, runCommand
, expect
, curl
, installShellFiles
}: type: args: stdenv.mkDerivation (finalAttrs: args // {
  doInstallCheck = true;

  # TODO: this should probably be postInstallCheck
  # TODO: send output to /dev/null
  installCheckPhase = args.installCheckPhase or "" + ''
    $out/bin/dotnet --info
  '';

  # TODO: move this to sdk section?
  setupHook = writeText "dotnet-setup-hook" (''
    if [ ! -w "$HOME" ]; then
      export HOME=$(mktemp -d) # Dotnet expects a writable home directory for its configuration files
    fi

    export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1 # Dont try to expand NuGetFallbackFolder to disk
    export DOTNET_NOLOGO=1 # Disables the welcome message
    export DOTNET_CLI_TELEMETRY_OPTOUT=1
    export DOTNET_SKIP_WORKLOAD_INTEGRITY_CHECK=1 # Skip integrity check on first run, which fails due to read-only directory
  '' + args.setupHook or "");

  nativeBuildInputs = (args.nativeBuildInputs or []) ++ [ installShellFiles ];

  postInstall = ''
    # completions snippets taken from https://learn.microsoft.com/en-us/dotnet/core/tools/enable-tab-autocomplete
    installShellCompletion --cmd dotnet \
      --bash ${./completions/dotnet.bash} \
      --zsh ${./completions/dotnet.zsh} \
      --fish ${./completions/dotnet.fish}
  '';

  passthru = {
    tests = let
      mkDotnetTest =
        {
          name,
          template,
          usePackageSource ? false,
          build,
          # TODO: use correct runtimes instead of sdk
          runtime ? finalAttrs.finalPackage,
          runInputs ? [],
          run ? null,
          runAllowNetworking ? false,
        }:
        let
          sdk = finalAttrs.finalPackage;
          built = runCommand "dotnet-test-${name}" {
            buildInputs = [ sdk ];
            # make sure ICU works in a sandbox
            propagatedSandboxProfile = toString sdk.__propagatedSandboxProfile + ''
              (allow network-inbound (local ip))
              (allow mach-lookup (global-name "com.apple.FSEvents"))
            '';
          } (''
            HOME=$PWD/.home
            dotnet new nugetconfig
            dotnet nuget disable source nuget
          '' + lib.optionalString usePackageSource ''
            dotnet nuget add source ${finalAttrs.finalPackage.packages}
          '' + ''
            dotnet new ${template} -n test -o .
          '' + build);
        in
          if run == null
            then built
          else
            runCommand "${built.name}-run" ({
              src = built;
              nativeBuildInputs = [ built ] ++ runInputs;
            } // lib.optionalAttrs (stdenv.isDarwin && runAllowNetworking) {
              sandboxProfile = ''
                (allow network-inbound (local ip))
                (allow mach-lookup (global-name "com.apple.FSEvents"))
              '';
              __darwinAllowLocalNetworking = true;
            }) (lib.optionalString (runtime != null) ''
              # TODO: use runtime here
              export DOTNET_ROOT=${runtime}
            '' + run);

      # Setting LANG to something other than 'C' forces the runtime to search
      # for ICU, which will be required in most user environments.
      checkConsoleOutput = command: ''
        output="$(LANG=C.UTF-8 ${command})"
        # yes, older SDKs omit the comma
        [[ "$output" =~ Hello,?\ World! ]] && touch "$out"
      '';

    in {
      version = testers.testVersion ({
        package = finalAttrs.finalPackage;
      } // lib.optionalAttrs (type != "sdk") {
        command = "dotnet --info";
      });
    }
    // lib.optionalAttrs (type == "sdk") {
      console = mkDotnetTest {
        name = "console";
        template = "console";
        build = checkConsoleOutput "dotnet run";
      };

      publish = mkDotnetTest {
        name = "publish";
        template = "console";
        build = "dotnet publish -o $out";
        run = checkConsoleOutput "$src/test";
      };

      self-contained = mkDotnetTest {
        name = "self-contained";
        template = "console";
        usePackageSource = true;
        build = "dotnet publish --use-current-runtime --sc -o $out";
        runtime = null;
        run = checkConsoleOutput "$src/test";
      };

      single-file = mkDotnetTest {
        name = "single-file";
        template = "console";
        usePackageSource = true;
        build = "dotnet publish --use-current-runtime -p:PublishSingleFile=true -o $out";
        runtime = null;
        run = checkConsoleOutput "$src/test";
      };

      web = mkDotnetTest {
        name = "web";
        template = "web";
        build = "dotnet publish -o $out";
        runInputs = [ expect curl ];
        run = ''
          expect <<"EOF"
            set status 1
            spawn $env(src)/test
            proc abort { } { exit 2 }
            expect_before default abort
            expect -re {Now listening on: ([^\r]+)\r} {
              set url $expect_out(1,string)
            }
            expect "Application started. Press Ctrl+C to shut down."
            set output [exec curl -sSf $url]
            if {$output != "Hello World!"} {
              send_error "Unexpected output: $output\n"
              exit 1
            }
            send \x03
            expect_before timeout abort
            expect eof
            catch wait result
            exit [lindex $result 3]
          EOF
          touch $out
        '';
        runAllowNetworking = true;
      };
    } // args.passthru.tests or {};
  } // args.passthru or {};
})
