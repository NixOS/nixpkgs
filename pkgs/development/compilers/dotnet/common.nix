# TODO: switch to stdenvNoCC
{
  stdenv,
  stdenvNoCC,
  lib,
  writeText,
  testers,
  runCommand,
  runCommandWith,
  expect,
  curl,
  installShellFiles,
  callPackage,
  zlib,
  swiftPackages,
  darwin,
  icu,
  lndir,
  substituteAll,
  nugetPackageHook,
  xmlstarlet,
}:
type: args:
stdenv.mkDerivation (
  finalAttrs:
  args
  // {
    doInstallCheck = true;

    # TODO: this should probably be postInstallCheck
    # TODO: send output to /dev/null
    installCheckPhase =
      args.installCheckPhase or ""
      + ''
        $out/bin/dotnet --info
      '';

    setupHooks =
      args.setupHooks or [ ]
      ++ [
        ./dotnet-setup-hook.sh
      ]
      ++ lib.optional (type == "sdk") (substituteAll {
        src = ./dotnet-sdk-setup-hook.sh;
        inherit lndir xmlstarlet;
      });

    propagatedBuildInputs =
      (args.propagatedBuildInputs or [ ])
      ++ lib.optional (type == "sdk") nugetPackageHook;

    nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [ installShellFiles ];

    postInstall = ''
      # completions snippets taken from https://learn.microsoft.com/en-us/dotnet/core/tools/enable-tab-autocomplete
      installShellCompletion --cmd dotnet \
        --bash ${./completions/dotnet.bash} \
        --zsh ${./completions/dotnet.zsh} \
        --fish ${./completions/dotnet.fish}
    '';

    passthru = {
      tests =
        let
          mkDotnetTest =
            {
              name,
              stdenv ? stdenvNoCC,
              template,
              usePackageSource ? false,
              build,
              buildInputs ? [ ],
              # TODO: use correct runtimes instead of sdk
              runtime ? finalAttrs.finalPackage,
              runInputs ? [ ],
              run ? null,
              runAllowNetworking ? false,
            }:
            let
              sdk = finalAttrs.finalPackage;
              built = stdenv.mkDerivation {
                name = "dotnet-test-${name}";
                buildInputs = [ sdk ] ++ buildInputs ++ lib.optional (usePackageSource) sdk.packages;
                # make sure ICU works in a sandbox
                propagatedSandboxProfile = toString sdk.__propagatedSandboxProfile;
                unpackPhase = ''
                  mkdir test
                  cd test
                  dotnet new ${template} -o . --no-restore
                '';
                buildPhase = build;
                dontPatchELF = true;
              };
            in
            if run == null then
              built
            else
              runCommand "${built.name}-run"
                (
                  {
                    src = built;
                    nativeBuildInputs = [ built ] ++ runInputs;
                    passthru = {
                      inherit built;
                    };
                  }
                  // lib.optionalAttrs (stdenv.hostPlatform.isDarwin && runAllowNetworking) {
                    sandboxProfile = ''
                      (allow network-inbound (local ip))
                      (allow mach-lookup (global-name "com.apple.FSEvents"))
                    '';
                    __darwinAllowLocalNetworking = true;
                  }
                )
                (
                  lib.optionalString (runtime != null) ''
                    # TODO: use runtime here
                    export DOTNET_ROOT=${runtime}
                  ''
                  + run
                );

          # Setting LANG to something other than 'C' forces the runtime to search
          # for ICU, which will be required in most user environments.
          checkConsoleOutput = command: ''
            output="$(LANG=C.UTF-8 ${command})"
            # yes, older SDKs omit the comma
            [[ "$output" =~ Hello,?\ World! ]] && touch "$out"
          '';
        in
        {
          version = testers.testVersion (
            {
              package = finalAttrs.finalPackage;
            }
            // lib.optionalAttrs (type != "sdk") {
              command = "dotnet --info";
            }
          );
        }
        // lib.optionalAttrs (type == "sdk") (
          {
            console = mkDotnetTest {
              name = "console";
              template = "console";
              build = checkConsoleOutput "dotnet run";
            };

            publish = mkDotnetTest {
              name = "publish";
              template = "console";
              build = "dotnet publish -o $out/bin";
              run = checkConsoleOutput "$src/bin/test";
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
              build = "dotnet publish --use-current-runtime -p:PublishSingleFile=true -o $out/bin";
              runtime = null;
              run = checkConsoleOutput "$src/bin/test";
            };

            web = mkDotnetTest {
              name = "web";
              template = "web";
              build = "dotnet publish -o $out/bin";
              runInputs = [
                expect
                curl
              ];
              run = ''
                expect <<"EOF"
                  set status 1
                  spawn $env(src)/bin/test
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
          }
          // lib.optionalAttrs finalAttrs.finalPackage.hasILCompiler {
            aot = mkDotnetTest {
              name = "aot";
              stdenv = if stdenv.hostPlatform.isDarwin then swiftPackages.stdenv else stdenv;
              template = "console";
              usePackageSource = true;
              buildInputs =
                [
                  zlib
                ]
                ++ lib.optional stdenv.hostPlatform.isDarwin (
                  with darwin;
                  with apple_sdk.frameworks;
                  [
                    swiftPackages.swift
                    Foundation
                    CryptoKit
                    GSS
                    ICU
                  ]
                );
              build = ''
                dotnet restore -p:PublishAot=true
                dotnet publish -p:PublishAot=true -o $out/bin
              '';
              runtime = null;
              run = checkConsoleOutput "$src/bin/test";
            };
          }
        )
        // args.passthru.tests or { };
    } // args.passthru or { };
  }
)
