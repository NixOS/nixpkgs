{
  lib,
  stdenv,
  fetchurl,
  mkfontscale,
  fonttosfnt,
  libfaketime,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unifont";
  version = "17.0.04";

  otf = fetchurl {
    url = "mirror://gnu/unifont/unifont-${finalAttrs.version}/unifont-${finalAttrs.version}.otf";
    hash = "sha256-0fZkqXU7nGt/81cSh0njK10+7pDHwDYYNj+r1Do5tbc=";
  };

  pcf = fetchurl {
    url = "mirror://gnu/unifont/unifont-${finalAttrs.version}/unifont-${finalAttrs.version}.pcf.gz";
    hash = "sha256-21hNQMglGdfPrx8VWP3lMT+/Guga7uoKbm72MqXjxJY=";
  };

  bdf = fetchurl {
    url = "mirror://gnu/unifont/unifont-${finalAttrs.version}/unifont-${finalAttrs.version}.bdf.gz";
    hash = "sha256-mi3kgmOIJCdxEhx/4A5BJSPDGDGLjuOOa+bNRU5+yAI=";
  };

  nativeBuildInputs = [
    libfaketime
    fonttosfnt
    mkfontscale
  ];

  dontUnpack = true;

  buildPhase = ''
    runHook preBuild

    # convert pcf font to otb
    faketime -f "1970-01-01 00:00:01" \
    fonttosfnt -g 2 -m 2 -v -o "unifont.otb" "${finalAttrs.pcf}"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # install otb fonts
    install -m 644 -D unifont.otb "$out/share/fonts/unifont.otb"
    mkfontdir "$out/share/fonts"

    # install pcf, otf, and bdf fonts
    install -m 644 -D ${finalAttrs.pcf} $out/share/fonts/unifont.pcf.gz
    install -m 644 -D ${finalAttrs.otf} $out/share/fonts/opentype/unifont.otf
    gunzip -c ${finalAttrs.bdf} > $out/share/fonts/unifont.bdf
    cd "$out/share/fonts"
    mkfontdir
    mkfontscale

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Unicode font for Base Multilingual Plane";
    homepage = "https://unifoundry.com/unifont/";

    # Basically GPL2+ with font exception.
    license = with lib.licenses; [
      gpl2Plus
      fontException
    ];
    maintainers = with lib.maintainers; [
      rycee
      qweered
    ];
    platforms = lib.platforms.all;
  };
})
