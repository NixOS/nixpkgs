{ stdenv, fetchurl, readline }:

stdenv.mkDerivation rec {
  name = "mujs-${version}";
  version = "1.0.5";

  src = fetchurl {
    url = "https://mujs.com/downloads/mujs-${version}.tar.xz";
    sha256 = "02cqrfnww2s3ylcvqin1951f2c5nzpby8gxb207p2hbrivbg8f0l";
  };

  buildInputs = [ readline ];

  makeFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    homepage = https://mujs.com/;
    description = "A lightweight, embeddable Javascript interpreter";
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
    license = licenses.gpl3;
  };
}
