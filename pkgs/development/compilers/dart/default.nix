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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dart";
  version = "3.10.9";

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
        x86_64-linux = "sha256-1DudOiG4LvKjfTGUW5nmuI9fjcROwZG0c/1inXjQuZQ=";
        aarch64-linux = "sha256-Z8mPnmppTtPLNiY0Ny1pRzBAs3EoNtQsr82zxWwKBOs=";
        x86_64-darwin = "sha256-pd37vWDOIKGdek/CuUSH7sVyiKqlLOW6GLT4IkzkwYA=";
        aarch64-darwin = "sha256-99gMhvkzSJmYEsGuD3kBN1e3l685Xyy6cNICegC+Vk4=";
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
    find $out/bin -executable -type f -exec patchelf --set-interpreter ${bintools.dynamicLinker} {} \;
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
