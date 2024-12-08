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
type: unwrapped:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "${unwrapped.pname}-wrapped";
  inherit (unwrapped) version meta;

  src = unwrapped;
  dontUnpack = true;

  setupHooks =
    [
      ./dotnet-setup-hook.sh
    ]
    ++ lib.optional (type == "sdk") (substituteAll {
      src = ./dotnet-sdk-setup-hook.sh;
      inherit lndir xmlstarlet;
    });

  propagatedSandboxProfile = toString unwrapped.__propagatedSandboxProfile;

  propagatedBuildInputs = lib.optional (type == "sdk") nugetPackageHook;

  nativeBuildInputs = [ installShellFiles ];

  outputs = [ "out" ] ++ lib.optional (unwrapped ? man) "man";

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"/bin "$out"/share
    ln -s "$src"/bin/* "$out"/bin
    ln -s "$src"/share/dotnet "$out"/share
    runHook postInstall
  '';

  postInstall = ''
    # completions snippets taken from https://learn.microsoft.com/en-us/dotnet/core/tools/enable-tab-autocomplete
    installShellCompletion --cmd dotnet \
      --bash ${./completions/dotnet.bash} \
      --zsh ${./completions/dotnet.zsh} \
      --fish ${./completions/dotnet.fish}
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/dotnet --info
    runHook postInstallCheck
  '';

  postFixup = lib.optionalString (unwrapped ? man) ''
    ln -s ${unwrapped.man} "$man"
  '';
  passthru = unwrapped.passthru // {
    inherit unwrapped;
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
            runtime ? finalAttrs.finalPackage.runtime,
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
                  export DOTNET_ROOT=${runtime}/share/dotnet
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
      unwrapped.passthru.tests or { }
      // {
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
            runtime = finalAttrs.finalPackage.aspnetcore;
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
      );
  };
})
