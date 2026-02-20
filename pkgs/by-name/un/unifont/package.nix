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
  version = "17.0.03";

  otf = fetchurl {
    url = "mirror://gnu/unifont/unifont-${finalAttrs.version}/unifont-${finalAttrs.version}.otf";
    hash = "sha256-JgccWpdTPO/cvGsGRefuJ5QTBJB58J9ZKyaRbKbCG/U=";
  };

  pcf = fetchurl {
    url = "mirror://gnu/unifont/unifont-${finalAttrs.version}/unifont-${finalAttrs.version}.pcf.gz";
    hash = "sha256-byijyRE71OdtTqYdymQV73yds1an+AuRbJFTlRsaj+0=";
  };

  bdf = fetchurl {
    url = "mirror://gnu/unifont/unifont-${finalAttrs.version}/unifont-${finalAttrs.version}.bdf.gz";
    hash = "sha256-MNUDAtrKYx4s9FTZdHEX2YyfNcCxivT2fS+l4RaZIDM=";
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
