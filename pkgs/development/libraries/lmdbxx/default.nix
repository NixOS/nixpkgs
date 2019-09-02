{ stdenv
, fetchFromGitHub
, lmdb }:

stdenv.mkDerivation rec {
  pname = "lmdbxx";
  version = "0.9.14.0";

  src = fetchFromGitHub {
    owner = "drycpp";
    repo = "lmdbxx";
    rev = "${version}";
    sha256 = "1jmb9wg2iqag6ps3z71bh72ymbcjrb6clwlkgrqf1sy80qwvlsn6";
  };

  buildInputs = [ lmdb ];
  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/drycpp/lmdbxx#readme";
    description = "C++11 wrapper for the LMDB embedded B+ tree database library";
    license = stdenv.lib.licenses.unlicense;
    maintainers = with stdenv.lib.maintainers; [ fgaz ];
  };
}

