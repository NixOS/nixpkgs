{ lib, stdenv
, fetchFromGitHub
, cmake
, gmp
, flint
, mpfr
, libmpc
}:

stdenv.mkDerivation rec {
  pname = "symengine";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "symengine";
    repo = "symengine";
    rev = "v${version}";
    sha256 = "sha256-5KpxBusJCuwrfFWHbrRKlH6Ic7YivYqz2m+BCbNfZp0=";
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

  meta = with lib; {
    description = "A fast symbolic manipulation library";
    homepage = "https://github.com/symengine/symengine";
    platforms = platforms.unix ++ platforms.windows;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };

}
