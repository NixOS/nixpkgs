{ lib, fetchurl }:

let
  version = "7.040";
in fetchurl rec {
  name = "libertinus-${version}";
  url = "https://github.com/alerque/libertinus/releases/download/v${version}/Libertinus-${version}.tar.xz";
  sha256 = "0z658r88p52dyrcslv0wlccw0sw7m5jz8nbqizv95nf7bfw96iyk";

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
