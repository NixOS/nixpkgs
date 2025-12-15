{
  lib,
  stdenv,
  fetchurl,
  unzip,
  bintools,
  versionCheckHook,
  runCommand,
  cctools,
  darwin,
  sources ? import ./sources.nix { inherit fetchurl; },
  version ? sources.versionUsed,
}:

assert sources != null && (builtins.isAttrs sources);
stdenv.mkDerivation (finalAttrs: {
  pname = "dart";
  inherit version;

  nativeBuildInputs = [ unzip ];

  src =
    sources."${version}-${stdenv.hostPlatform.system}"
      or (throw "unsupported version/system: ${version}/${stdenv.hostPlatform.system}");

  installPhase = ''
    runHook preInstall

    cp -R . $out
  ''
  + lib.optionalString (stdenv.hostPlatform.isLinux) ''
    find $out/bin -executable -type f -exec patchelf --set-interpreter ${bintools.dynamicLinker} {} \;
  ''
  + ''
    runHook postInstall
  '';

  dontStrip = true;

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "--version";

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
    maintainers = with lib.maintainers; [ grburst ];
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
  };
})
