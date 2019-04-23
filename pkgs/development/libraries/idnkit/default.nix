{ stdenv, fetchurl, libiconv }:

stdenv.mkDerivation rec {
  name = "idnkit-${version}";
  version = "2.3";

  src = fetchurl {
    url = "https://jprs.co.jp/idn/${name}.tar.bz2";
    sha256 = "0zp9yc84ff5s0g2i6v9yfyza2n2x4xh0kq7hjd3anhh0clbp3l16";
  };

  buildInputs = [ libiconv ];

  meta = with stdenv.lib; {
    homepage = https://www.nic.ad.jp/ja/idn/idnkit;
    description = "Provides functionalities about i18n domain name processing";
    license = "idnkit-2 license";
    platforms = platforms.linux;
  };
}
