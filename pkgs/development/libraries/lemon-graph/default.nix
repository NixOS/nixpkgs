{ lib
, stdenv
, fetchurl
, cmake
}:

stdenv.mkDerivation rec {
  pname = "lemon-graph";
  version = "1.3.1";

  src = fetchurl {
    url = "https://lemon.cs.elte.hu/pub/sources/lemon-${version}.tar.gz";
    sha256 = "1j6kp9axhgna47cfnmk1m7vnqn01hwh7pf1fp76aid60yhjwgdvi";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://lemon.cs.elte.hu/trac/lemon";
    description = "Efficient library for combinatorial optimization tasks on graphs and networks";
    license = licenses.boost;
    maintainers = with maintainers; [ trepetti ];
    platforms = platforms.all;
    broken = stdenv.isAarch64 || stdenv.isDarwin;
  };
}
