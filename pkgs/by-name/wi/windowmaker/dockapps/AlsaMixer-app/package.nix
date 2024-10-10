{
  lib,
  alsa-lib,
  libX11,
  libXext,
  libXpm,
  pkg-config,
  stdenv,
  windowmaker,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "AlsaMixer.app";
  inherit (windowmaker.dockapps.dockapps-sources) version;

  src = windowmaker.dockapps.dockapps-sources;

  sourceRoot = "${finalAttrs.src.name}/AlsaMixer.app";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    alsa-lib
    libX11
    libXpm
    libXext
  ];

  hardeningDisable = [ "fortify" ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    install -D -t ${placeholder "out"}/bin/ AlsaMixer.app
    pushd ${placeholder "out"}/bin
    ln -s AlsaMixer.app AlsaMixer
    popd

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.dockapps.net/alsamixerapp";
    description = "Alsa mixer application for Windowmaker";
    license = lib.licenses.gpl2Plus;
    mainProgram = "AlsaMixer";
    inherit (windowmaker.meta) maintainers platforms;
  };
})
