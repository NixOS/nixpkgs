{ lib
, stdenv
, fetchFromGitHub
, lmdb
}:

stdenv.mkDerivation rec {
  pname = "lmdbxx";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "hoytech";
    repo = "lmdbxx";
    rev = version;
    sha256 = "12k5rz74d1l0skcks9apry1svkl96g9lf5dcgylgjmh7v1jm0b7c";
  };

  buildInputs = [ lmdb ];
  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/hoytech/lmdbxx#readme";
    description = "C++11 wrapper for the LMDB embedded B+ tree database library";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ fgaz ];
  };
}
