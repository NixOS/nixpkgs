{ stdenv, fetchurl, cmake
, parallel ? true
}:

stdenv.mkDerivation rec {
  name = "stxxl-${version}";
  version = "1.4.1";

  src = fetchurl {
    url = "https://github.com/stxxl/stxxl/archive/${version}.tar.gz";
    sha256 = "54006a5fccd1435abc2f3ec201997a4d7dacddb984d2717f62191798e5372f6c";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_STATIC_LIBS=OFF"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DUSE_GNU_PARALLEL=${if parallel then "ON" else "OFF"}"
  ];

  passthru = {
    inherit parallel;
  };

  meta = with stdenv.lib; {
    description = "An implementation of the C++ standard template library STL for external memory (out-of-core) computations";
    homepage = https://github.com/stxxl/stxxl;
    license = licenses.boost;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
