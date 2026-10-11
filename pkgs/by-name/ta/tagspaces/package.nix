{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  electron,
  autoPatchelfHook,
  libgcc,
  glib,
  nss,
  at-spi2-atk,
  cups,
  libdrm,
  gtk3,
  mesa,
  alsa-lib,
  libGL,
  libnotify,
  libsecret,
}:

stdenv.mkDerivation rec {
  pname = "tagspaces";
  version = "5.9.2";

  src = fetchurl {
    url = "https://github.com/tagspaces/tagspaces/releases/download/v${version}/tagspaces-linux-amd64-${version}.deb";
    hash = "sha256-0D9ZXWaaFcKyySTAfGxA3svjSKPKD1EVPR9yoa35Nes=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
    dpkg
  ] ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.isLinux [
    libgcc.libgcc
    glib
    nss
    at-spi2-atk
    cups
    libdrm
    gtk3
    mesa
    alsa-lib
    libGL
  ];

  runtimeDependencies = lib.optionals stdenv.isLinux [
    libGL
    libnotify
    libsecret
  ];

  dontAutoPatchelf = true;

  unpackPhase = "dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt $out/share
    cp -R opt/TagSpaces $out/opt/
    cp -R usr/share/{applications,icons} $out/share
    substituteInPlace $out/share/applications/tagspaces.desktop \
      --replace-fail "/opt/TagSpaces/tagspaces" "$out/bin/tagspaces"

    makeWrapper ${electron}/bin/electron $out/bin/tagspaces \
      --add-flags $out/opt/TagSpaces/resources/app.asar \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    runHook postInstall
  '';

  fixupPhase = lib.optionalString stdenv.isLinux ''
    runHook preFixup

    autoPatchelf $out/opt/TagSpaces/resources

    runHook postFixup
  '';

  meta = {
    description = "Free, no vendor lock-in, open source application for managing local files with the help of tags";
    changelog = "https://github.com/tagspaces/tagspaces/blob/develop/CHANGELOG.md";
    homepage = "https://www.tagspaces.org";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ gador ];
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    mainProgram = "tagspaces";
  };
}
