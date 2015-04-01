{stdenv, fetchurl, cmake, parallel ? true }:

stdenv.mkDerivation rec {
  name = "stxxl-1.4.1";

  src = fetchurl {
    url = "https://github.com/stxxl/stxxl/archive/1.4.1.tar.gz";
    sha256 = "54006a5fccd1435abc2f3ec201997a4d7dacddb984d2717f62191798e5372f6c";
  };

  buildInputs = [ cmake ];

  cmakeFlags = let parallel_str = if parallel then "ON" else "OFF"; in "-DUSE_GNU_PARALLEL=${parallel_str}";

  passthru = {
    inherit parallel;
  };

  meta = {
    homepage = https://github.com/stxxl/stxxl;
    description = "STXXL is an implementation of the C++ standard template library STL for external memory (out-of-core) computations.";
    license = stdenv.lib.licenses.boost;
  };
}
