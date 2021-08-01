{ lib, fetchurl }:

let
  version = "7.040";
in fetchurl rec {
  name = "libertinus-${version}";
  url = "https://github.com/alerque/libertinus/releases/download/v${version}/Libertinus-${version}.tar.xz";
  sha256 = "sha256-GT2kBfTCP1lf8SYG0z6iii/1482hx3uUNsPTCrM+DKQ=";

  downloadToTemp = true;
  recursiveHash = true;

  postFetch = ''
    tar xf $downloadedFile --strip=1
    install -m644 -Dt $out/share/fonts/opentype static/OTF/*.otf
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
