{ lib
, stdenv
, fetchurl
, fuse
, ncurses
, python3
}:

stdenv.mkDerivation rec {
  pname = "libbde";
  version = "20220121";

  src = fetchurl {
    url = "https://github.com/libyal/libbde/releases/download/${version}/${pname}-alpha-${version}.tar.gz";
    sha256 = "sha256-dnSMuTm/nMiZ6t2rbhDqGpp/e9xt5Msz2In8eiuTjC8=";
  };

  buildInputs = [ fuse ncurses python3 ];

  configureFlags = [ "--enable-python" ];

  meta = with lib; {
    description = "Library to access the BitLocker Drive Encryption (BDE) format";
    homepage = "https://github.com/libyal/libbde/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ eliasp ];
    platforms = platforms.all;
  };
}
