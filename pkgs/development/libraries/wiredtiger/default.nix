{ stdenv, fetchFromGitHub, automake, autoconf, libtool
, bzip2, snappy, zlib, db
}:

stdenv.mkDerivation rec {
  name = "wiredtiger-${version}";
  version = "2.5.2";

  src = fetchFromGitHub {
    repo = "wiredtiger";
    owner = "wiredtiger";
    rev = version;
    sha256 = "1rk26gfs4zpz88mkbdkhz65q4admpgf46x5zsnghl0ndirmnvq3p";
  };

  nativeBuildInputs = [ automake autoconf libtool ];
  buildInputs = [ bzip2 snappy zlib db ];

  configureFlags = [
    "--with-berkeleydb=${db}"
    "--enable-bzip2"
    "--enable-leveldb"
    "--enable-snappy"
    "--enable-zlib"
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    homepage = http://wiredtiger.com/;
    description = "";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
