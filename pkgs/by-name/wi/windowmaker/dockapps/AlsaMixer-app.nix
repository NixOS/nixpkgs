{
  lib,
  stdenv,
  alsa-lib,
  dockapps-sources,
  libX11,
  libXext,
  libXpm,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "AlsaMixer.app";

  inherit (dockapps-sources) version src;

  sourceRoot = "${finalAttrs.src.name}/AlsaMixer.app";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    libX11
    libXpm
    libXext
  ];

  hardeningDisable = [ "fortify" ];

  dontConfigure = true;

  installPhase = ''
    runHook preInstall
    install -D -t ${placeholder "out"}/bin/ AlsaMixer.app
    pushd ${placeholder "out"}/bin
    ln -vs AlsaMixer.app AlsaMixer
    runHook postInstall
  '';

  meta = {
    description = "Alsa mixer application for Windowmaker";
    homepage = "https://www.dockapps.net/alsamixerapp";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
})
