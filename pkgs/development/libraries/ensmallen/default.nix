{ stdenv, lib, armadillo, cmake, fetchFromGitHub, openmp ? null, enableOpenMP ? false }:
assert enableOpenMP -> openmp != null;

stdenv.mkDerivation rec {
  pname = "ensmallen";
  version = "2.10.3";

  src = fetchFromGitHub {
    owner = "mlpack";
    repo = pname;
    rev = version;
    sha256 = "sha256-pLpBPnFfkqd6M1wbmuxxTb+/XwE1PtcZyLgm7ozwDVk=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ armadillo ] ++ (lib.optional enableOpenMP openmp);

  cmakeFlags = [ "-DUSE_OPENMP=${if enableOpenMP then "ON" else "OFF"}" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A header-only C++ library for mathematical optimization";
    homepage = "https://ensmallen.org/";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ aminechikhaoui ];
  };
}
