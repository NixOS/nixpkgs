{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "sparsehash";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "sparsehash";
    repo = "sparsehash";
    rev = "sparsehash-${version}";
    sha256 = "1pf1cjvcjdmb9cd6gcazz64x0cd2ndpwh6ql2hqpypjv725xwxy7";
  };

  meta = with lib; {
    homepage = "https://github.com/sparsehash/sparsehash";
    description = "An extremely memory-efficient hash_map implementation";
    platforms = platforms.all;
    license = licenses.bsd3;
    maintainers = with maintainers; [ pSub ];
  };
}
