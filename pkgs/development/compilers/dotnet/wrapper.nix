{
  stdenv,
  stdenvNoCC,
  lib,
  writeText,
  testers,
  runCommand,
  runCommandWith,
  darwin,
  expect,
  curl,
  installShellFiles,
  callPackage,
  zlib,
  swiftPackages,
  icu,
  lndir,
  replaceVars,
  nugetPackageHook,
  xmlstarlet,
  pkgs,
  recurseIntoAttrs,
}:
type: unwrapped:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "${unwrapped.pname}-wrapped";
  inherit (unwrapped) version;

  meta = {
    description = "${unwrapped.meta.description or "dotnet"} (wrapper)";
    mainProgram = "dotnet";
    inherit (unwrapped.meta)
      homepage
      license
      maintainers
      platforms
      ;
  };

  src = unwrapped;
  dontUnpack = true;

  setupHooks = [
    ./dotnet-setup-hook.sh
  ]
  ++ lib.optional (type == "sdk") (
    replaceVars ./dotnet-sdk-setup-hook.sh {
      inherit lndir xmlstarlet;
    }
  );

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
    HOME=$(mktemp -d) $out/bin/dotnet --info
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
            lang ? null,
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
              name = "${sdk.name}-test-${name}";
              buildInputs = [ sdk ] ++ buildInputs ++ lib.optional (usePackageSource) sdk.packages;
              # make sure ICU works in a sandbox
              propagatedSandboxProfile = toString sdk.__propagatedSandboxProfile;
              unpackPhase =
                let
                  unpackArgs = [
                    template
                  ]
                  ++ lib.optionals (lang != null) [
                    "-lang"
                    lang
                  ];
                in
                ''
                  mkdir test
                  cd test
                  dotnet new ${lib.escapeShellArgs unpackArgs} -o . --no-restore
                '';
              buildPhase = build;
              dontPatchELF = true;
            };
          in
          # older SDKs don't include an embedded FSharp.Core package
          if lang == "F#" && lib.versionOlder sdk.version "6.0.400" then
            null
          else if run == null then
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

        mkConsoleTests =
          lang: suffix: output:
          let
            # Setting LANG to something other than 'C' forces the runtime to search
            # for ICU, which will be required in most user environments.
            checkConsoleOutput = command: ''
              output="$(LANG=C.UTF-8 ${command})"
              [[ "$output" =~ ${output} ]] && touch "$out"
            '';

            mkConsoleTest =
              { name, ... }@args:
              mkDotnetTest (
                args
                // {
                  name = "console-${name}-${suffix}";
                  template = "console";
                  inherit lang;
                }
              );
          in
          lib.recurseIntoAttrs {
            run = mkConsoleTest {
              name = "run";
              build = checkConsoleOutput "dotnet run";
            };

            publish = mkConsoleTest {
              name = "publish";
              build = "dotnet publish -o $out/bin";
              run = checkConsoleOutput "$src/bin/test";
            };

            self-contained = mkConsoleTest {
              name = "self-contained";
              usePackageSource = true;
              build = "dotnet publish --use-current-runtime --sc -o $out";
              runtime = null;
              run = checkConsoleOutput "$src/test";
            };

            single-file = mkConsoleTest {
              name = "single-file";
              usePackageSource = true;
              build = "dotnet publish --use-current-runtime -p:PublishSingleFile=true -o $out/bin";
              runtime = null;
              run = checkConsoleOutput "$src/bin/test";
            };

            ready-to-run = mkConsoleTest {
              name = "ready-to-run";
              usePackageSource = true;
              build = "dotnet publish --use-current-runtime -p:PublishReadyToRun=true -o $out/bin";
              run = checkConsoleOutput "$src/bin/test";
            };
          }
          // lib.optionalAttrs finalAttrs.finalPackage.hasILCompiler {
            aot = mkConsoleTest {
              name = "aot";
              stdenv = if stdenv.hostPlatform.isDarwin then swiftPackages.stdenv else stdenv;
              usePackageSource = true;
              buildInputs = [
                zlib
              ]
              ++ lib.optional stdenv.hostPlatform.isDarwin [
                swiftPackages.swift
                darwin.ICU
              ];
              build = ''
                dotnet restore -p:PublishAot=true
                dotnet publish -p:PublishAot=true -o $out/bin
              '';
              runtime = null;
              run = checkConsoleOutput "$src/bin/test";
            };
          };

        mkWebTest =
          lang: suffix:
          mkDotnetTest {
            name = "web-${suffix}";
            template = "web";
            inherit lang;
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
      in
      unwrapped.passthru.tests or { }
      // {
        version = testers.testVersion {
          package = finalAttrs.finalPackage;
          command = "HOME=$(mktemp -d) dotnet " + (if type == "sdk" then "--version" else "--info");
        };
      }
      // lib.optionalAttrs (type == "sdk") ({
        buildDotnetModule = recurseIntoAttrs (
          (pkgs.appendOverlays [
            (self: super: {
              dotnet-sdk = finalAttrs.finalPackage;
              dotnet-runtime = finalAttrs.finalPackage.runtime;
            })
          ]).callPackage
            ../../../test/dotnet/default.nix
            { }
        );

        console = lib.recurseIntoAttrs {
          # yes, older SDKs omit the comma
          cs = mkConsoleTests "C#" "cs" "Hello,?\\ World!";
          fs = mkConsoleTests "F#" "fs" "Hello\\ from\\ F#";
          vb = mkConsoleTests "VB" "vb" "Hello,?\\ World!";
        };

        web = lib.recurseIntoAttrs {
          cs = mkWebTest "C#" "cs";
          fs = mkWebTest "F#" "fs";
        };
      });
  };
})
