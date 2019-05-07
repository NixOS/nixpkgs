{ stdenv
, fetchFromGitHub
, cmake
, gmp
, flint
, mpfr
, libmpc
}:

stdenv.mkDerivation rec {
  name = "symengine-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "symengine";
    repo = "symengine";
    rev = "v${version}";
    sha256 = "1kz893p3pmsw3gfwickk2nliw8p63yp89xriad7kpw4kmhvgr8gb";
  };

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

  meta = with stdenv.lib; {
    description = "SymEngine is a fast symbolic manipulation library";
    homepage = https://github.com/symengine/symengine;
    platforms = platforms.unix ++ platforms.windows;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };

}
