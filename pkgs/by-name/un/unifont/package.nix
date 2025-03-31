{
  lib,
  stdenv,
  fetchurl,
  xorg,
  libfaketime,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unifont";
  version = "16.0.02";

  otf = fetchurl {
    url = "mirror://gnu/unifont/unifont-${finalAttrs.version}/unifont-${finalAttrs.version}.otf";
    hash = "sha256-3oI6EOZeIkOt56mK+CuC68a71c89CqPjjtTMzTa8qzM=";
  };

  pcf = fetchurl {
    url = "mirror://gnu/unifont/unifont-${finalAttrs.version}/unifont-${finalAttrs.version}.pcf.gz";
    hash = "sha256-AqP+EZlNPNrx1L1dK2tglzXmgj4BdkroO3BOAuwvZA0=";
  };

  bdf = fetchurl {
    url = "mirror://gnu/unifont/unifont-${finalAttrs.version}/unifont-${finalAttrs.version}.bdf.gz";
    hash = "sha256-Uh8rkui2vU6hkM6gSaA53eNZpuLK6UWORdaWAI+mmX8=";
  };

  nativeBuildInputs = [
    libfaketime
    xorg.fonttosfnt
    xorg.mkfontscale
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

  meta = with lib; {
    description = "Unicode font for Base Multilingual Plane";
    homepage = "https://unifoundry.com/unifont/";

    # Basically GPL2+ with font exception.
    license = "https://unifoundry.com/LICENSE.txt";
    maintainers = [ maintainers.rycee ];
    platforms = platforms.all;
  };
})
