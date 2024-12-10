{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "libertinus";
  version = "7.040";

  src = fetchurl {
    url = "https://github.com/alerque/libertinus/releases/download/v${version}/Libertinus-${version}.tar.xz";
    hash = "sha256-f+nwInItHBzGfcLCihELO7VbrjV1GWFg0kIsiTM7OFA=";
  };

  installPhase = ''
    runHook preInstall

    install -m644 -Dt $out/share/fonts/opentype static/OTF/*.otf

    runHook postInstall
  '';

  meta = with lib; {
    description = "The Libertinus font family";
    longDescription = ''
      The Libertinus font project began as a fork of the Linux Libertine and
      Linux Biolinum fonts. The original impetus was to add an OpenType math
      companion to the Libertine font families. Over time it grew into to a
      full-fledged fork addressing many of the bugs in the Libertine fonts.
    '';
    homepage = "https://github.com/alerque/libertinus";
    license = licenses.ofl;
    maintainers = with maintainers; [ siddharthist ];
    platforms = platforms.all;
  };
}
