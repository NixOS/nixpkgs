{ lib
, stdenv
, fetchFromGitHub
, cmake
, gmp
, flint
, mpfr
, libmpc
, withShared ? true
}:

stdenv.mkDerivation rec {
  pname = "symengine";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "symengine";
    repo = "symengine";
    rev = "v${version}";
    hash = "sha256-SfifujR2VM1OlPN0ZRUC3hWImXO/8PuiyrBdpyNoKW4=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ gmp flint mpfr libmpc ];

  cmakeFlags = [
    "-DWITH_FLINT=ON"
    "-DINTEGER_CLASS=flint"
    "-DWITH_SYMENGINE_THREAD_SAFE=yes"
    "-DWITH_MPC=yes"
    "-DBUILD_FOR_DISTRIBUTION=yes"
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    # error: unrecognized instruction mnemonic, did you mean: bit, cnt, hint, ins, not?
    "-DBUILD_TESTS=OFF"
  ] ++ lib.optionals withShared [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  doCheck = true;

  meta = with lib; {
    description = "A fast symbolic manipulation library";
    homepage = "https://github.com/symengine/symengine";
    platforms = platforms.unix ++ platforms.windows;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };

}
