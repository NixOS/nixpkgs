{ stdenv
, lib
, fetchurl
, dpkg
, autoPatchelfHook
, wrapGAppsHook
, alsa-lib
, cups
, libGL
, libX11
, libXScrnSaver
, libXtst
, mesa
, nss
, gtk3
, libpulseaudio
, systemd
, withTetrioPlus ? false # For backwards compatibility. At the time of writing, the latest released tetrio plus version is not compatible with tetrio desktop.
, tetrio-plus ? false # For backwards compatibility. At the time of writing, the latest released tetrio plus version is not compatible with tetrio desktop.
}:

lib.warnIf (withTetrioPlus != false) "withTetrioPlus: Currently unsupported with tetrio-desktop 9.0.0. Please remove this attribute."
lib.warnIf (tetrio-plus != false) "tetrio-plus: Currently unsupported with tetrio-desktop 9.0.0. Please remove this attribute."

(let
  libPath = lib.makeLibraryPath [
    libGL
    libpulseaudio
    systemd
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "tetrio-desktop";
  version = "9.0.0";

  src = fetchurl {
    url = "https://tetr.io/about/desktop/builds/${lib.versions.major finalAttrs.version}/TETR.IO%20Setup.deb";
    hash = "sha256-UriLwMB8D+/T32H4rPbkJAy/F/FFhNpd++0AR1lwEfs=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook
  ];

  dontWrapGApps = true;

  buildInputs = [
    alsa-lib
    cups
    libX11
    libXScrnSaver
    libXtst
    mesa
    nss
    gtk3
  ];

  unpackCmd = "dpkg -x $curSrc src";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r opt/ usr/share/ $out
    ln -s $out/opt/TETR.IO/TETR.IO $out/bin/tetrio

    substituteInPlace $out/share/applications/TETR.IO.desktop \
      --replace-fail "Exec=/opt/TETR.IO/TETR.IO" "Exec=$out/bin/tetrio"

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/opt/TETR.IO/TETR.IO \
      --prefix LD_LIBRARY_PATH : ${libPath}:$out/opt/TETR.IO \
      ''${gappsWrapperArgs[@]}
  '';

  meta = {
    description = "TETR.IO desktop client";
    downloadPage = "https://tetr.io/about/desktop/";
    homepage = "https://tetr.io";
    license = lib.licenses.unfree;
    longDescription = ''
      TETR.IO is a modern yet familiar online stacker.
      Play against friends and foes all over the world, or claim a spot on the leaderboards - the stacker future is yours!
    '';
    mainProgram = "tetrio";
    maintainers = with lib.maintainers; [ wackbyte ];
    platforms = [ "x86_64-linux" ];
  };
}))
