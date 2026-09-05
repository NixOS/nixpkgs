{
  stdenv,
  lib,
  fetchFromGitHub,
  gradle,
  jdk21,
  desktopToDarwinBundle,
  makeWrapper,
  makeBinaryWrapper,
  jre,
  libGL,
  libpulseaudio,
  libxxf86vm,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unciv";
  version = "4.21.14";

  src = fetchFromGitHub {
    owner = "yairm210";
    repo = "Unciv";
    tag = finalAttrs.version;
    hash = "sha256-pc0pdx5Paioj8h3vgoOms9iRyJwm0SOJCIQ5hp9rV+M=";
  };

  nativeBuildInputs = [
    gradle
    jdk21
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
    makeBinaryWrapper
  ];

  # Gradle needs to bind
  __darwinAllowLocalNetworking = true;

  env.JAVA_HOME = jdk21;

  gradleBuildTask = ":desktop:dist";

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  installPhase = ''
    runHook preInstall

    install -d $out/share/unciv $out/bin
    cp desktop/build/libs/Unciv.jar $out/share/unciv/

    install -Dm444 "extraImages/Icons/Unciv icon v6.png" "$out/share/icons/hicolor/512x512/apps/unciv.png"

    install -Dm644 desktop/linuxFilesForJar/unciv.desktop $out/share/applications/unciv.desktop

    makeShellWrapper ${lib.getExe' jre "java"} $out/bin/unciv \
      --prefix LD_LIBRARY_PATH : "${finalAttrs.passthru.libraries}" \
      --add-flags "-jar $out/share/unciv/Unciv.jar" \
      --append-flags '--data-dir=$HOME/.local/share/unciv'     # relies on the shell expanding $HOME at runtime

    runHook postInstall
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Launch Services refuses to launch an app
    # bundle whose executable is a symlink into the Nix store.
    rm "$out/Applications/Unciv.app/Contents/MacOS/Unciv"
    makeBinaryWrapper "$out/bin/unciv" "$out/Applications/Unciv.app/Contents/MacOS/Unciv"
  '';

  passthru = {
    libraries = lib.makeLibraryPath (
      [
        libGL
        libpulseaudio
      ]
      ++ lib.optional stdenv.hostPlatform.isLinux libxxf86vm
    );
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Open-source Android/Desktop remake of Civ V";
    mainProgram = "unciv";
    homepage = "https://github.com/yairm210/Unciv";
    changelog = "https://github.com/yairm210/Unciv/blob/master/changelog.md";
    maintainers = with lib.maintainers; [
      iedame
      philocalyst
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = lib.licenses.mpl20;
    platforms = lib.platforms.all;
  };
})
