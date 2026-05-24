{
  lib,
  stdenv,
  fetchurl,
  unzip,
  versionCheckHook,
  runCommand,
  cctools,
  darwin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dart";
  version = "3.11.6";

  src =
    let
      selectSystem =
        attrs:
        attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
      system = selectSystem {
        x86_64-linux = "linux-x64";
        aarch64-linux = "linux-arm64";
        x86_64-darwin = "macos-x64";
        aarch64-darwin = "macos-arm64";
      };
      hash = selectSystem {
        x86_64-linux = "sha256-6g/yOW6lr0Aro1mKkTmg9LGzRx2dfoNIgtFVliJ2Ct0=";
        aarch64-linux = "sha256-PBKZ9GjroP13z5uC1+doOCwemAg3tgyndKLOtPnX20s=";
        x86_64-darwin = "sha256-gccm33wZaltIGlHOwExsECxRyOFMeW+FdZvu7M7Ychw=";
        aarch64-darwin = "sha256-09iIdY8xOvDLp03MoVfShBdyyW4NR8ZN1SvVTc8Rr3Y=";
      };
    in
    fetchurl {
      url = "https://storage.googleapis.com/dart-archive/channels/${
        if lib.strings.hasSuffix ".beta" finalAttrs.version then "beta" else "stable"
      }/release/${finalAttrs.version}/sdk/dartsdk-${system}-release.zip";
      inherit hash;
    };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    rm LICENSE README revision
    cp -R . $out
  ''
  + lib.optionalString (stdenv.hostPlatform.isLinux) ''
    find $out/bin -type f -executable | while read f; do
      if patchelf --print-interpreter "$f" >/dev/null 2>&1; then
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
                 --set-rpath "${lib.makeLibraryPath [ (lib.getLib stdenv.cc.cc) ]}" "$f"
      fi
    done
  ''
  + ''
    runHook postInstall
  '';

  dontStrip = true;

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    fetchGitHashesScript = ./fetch-git-hashes.py;
    updateScript = ./update.sh;
    tests = {
      testCreate = runCommand "dart-test-create" { nativeBuildInputs = [ finalAttrs.finalPackage ]; } ''
        PROJECTNAME="dart_test_project"
        dart create --no-pub $PROJECTNAME

        [[ -d $PROJECTNAME ]]
        [[ -f $PROJECTNAME/bin/$PROJECTNAME.dart ]]
        touch $out
      '';

      testCompile =
        runCommand "dart-test-compile"
          {
            nativeBuildInputs = [
              finalAttrs.finalPackage
            ]
            ++ lib.optionals stdenv.hostPlatform.isDarwin [
              cctools
              darwin.sigtool
            ];
          }
          ''
            HELLO_MESSAGE="Hello, world!"
            echo "void main() => print('$HELLO_MESSAGE');" > hello.dart
            dart compile exe hello.dart
            PROGRAM_OUT=$(./hello.exe)

            [[ "$PROGRAM_OUT" == "$HELLO_MESSAGE" ]]
            touch $out
          '';
    };
  };

  meta = {
    homepage = "https://dart.dev";
    maintainers = [ ];
    description = "Scalable programming language, with robust libraries and runtimes, for building web, server, and mobile apps";
    longDescription = ''
      Dart is a class-based, single inheritance, object-oriented language
      with C-style syntax. It offers compilation to JavaScript, interfaces,
      mixins, abstract classes, reified generics, and optional typing.
    '';
    mainProgram = "dart";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.bsd3;
    teams = [ lib.teams.flutter ];
  };
})
