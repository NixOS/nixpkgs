{ lib, stdenv, fetchurl, cmake
, parallel ? true
}:

let
  mkFlag = optset: flag: if optset then "-D${flag}=ON" else "-D${flag}=OFF";
in

stdenv.mkDerivation rec {
  pname = "stxxl";
  version = "1.4.1";

  src = fetchurl {
    url = "https://github.com/stxxl/stxxl/archive/${version}.tar.gz";
    sha256 = "54006a5fccd1435abc2f3ec201997a4d7dacddb984d2717f62191798e5372f6c";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_STATIC_LIBS=OFF"
    (mkFlag parallel "USE_GNU_PARALLEL")
  ];

  passthru = {
    inherit parallel;
  };

  meta = with lib; {
    description = "An implementation of the C++ standard template library STL for external memory (out-of-core) computations";
    homepage = "https://github.com/stxxl/stxxl";
    license = licenses.boost;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
