{ stdenv, fetchurl, mkfontdir, mkfontscale }:

stdenv.mkDerivation rec {
  pname = "spleen";
  version = "1.0.4";

  src = fetchurl {
    url = "https://github.com/fcambus/spleen/releases/download/${version}/spleen-${version}.tar.gz";
    sha256 = "1x62a5ygn3rpgzbaacz64rp8mn7saymdnxci4l3xasvsjjp60s3g";
  };

  buildPhase = "gzip -n9 *.pcf";
  installPhase = ''
    d="$out/share/fonts/X11/misc/spleen"
    install -Dm644 *.pcf.gz  -t $d
    install -Dm644 *.bdf -t $d
    install -m644 fonts.alias-spleen $d/fonts.alias
  '';

  meta = with stdenv.lib; {
    description = "Monospaced bitmap fonts";
    homepage = https://www.cambus.net/spleen-monospaced-bitmap-fonts;
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
