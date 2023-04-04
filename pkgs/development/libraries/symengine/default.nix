{ lib, stdenv
, fetchFromGitHub
, cmake
, gmp
, flint
, mpfr
, libmpc
, catch
}:

stdenv.mkDerivation rec {
  pname = "symengine";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "symengine";
    repo = "symengine";
    rev = "v${version}";
    sha256 = "sha256-qTu0vS9K6rrr/0SXKpGC9P1QSN/AN7hyO/4DrGvhxWM=";
  };

  postPatch = ''
    cp ${catch}/include/catch/catch.hpp symengine/utilities/catch/catch.hpp
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [ gmp flint mpfr libmpc ];

  cmakeFlags = [
    "-DWITH_FLINT=ON"
    "-DINTEGER_CLASS=flint"
    "-DWITH_SYMENGINE_THREAD_SAFE=yes"
    "-DWITH_MPC=yes"
    "-DBUILD_FOR_DISTRIBUTION=yes"
  ];

  doCheck = true;

  checkPhase = ''
    ctest
  '';

  meta = with lib; {
    description = "A fast symbolic manipulation library";
    homepage = "https://github.com/symengine/symengine";
    platforms = platforms.unix ++ platforms.windows;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };

}
