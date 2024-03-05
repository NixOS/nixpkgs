{ lib, stdenv, fetchurl, libiconv }:

stdenv.mkDerivation rec {
  pname = "idnkit";
  version = "2.3";

  src = fetchurl {
    url = "https://jprs.co.jp/idn/${pname}-${version}.tar.bz2";
    sha256 = "0zp9yc84ff5s0g2i6v9yfyza2n2x4xh0kq7hjd3anhh0clbp3l16";
  };

  buildInputs = [ libiconv ];

  meta = with lib; {
    homepage = "https://jprs.co.jp/idn/index-e.html";
    description = "Provides functionalities about i18n domain name processing";
    license = {
      fullName = "Open Source Code License version 1.1";
      url = "https://jprs.co.jp/idn/idnkit2-OSCL.txt";
    };
    platforms = platforms.linux;
  };
}
