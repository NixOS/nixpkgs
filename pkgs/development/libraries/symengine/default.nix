<<<<<<< HEAD
{ lib
, stdenv
=======
{ lib, stdenv
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitHub
, cmake
, gmp
, flint
, mpfr
, libmpc
<<<<<<< HEAD
, withShared ? true
=======
, catch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "symengine";
<<<<<<< HEAD
  version = "0.10.1";
=======
  version = "0.9.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "symengine";
    repo = "symengine";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-qTu0vS9K6rrr/0SXKpGC9P1QSN/AN7hyO/4DrGvhxWM=";
  };

=======
    sha256 = "sha256-5KpxBusJCuwrfFWHbrRKlH6Ic7YivYqz2m+BCbNfZp0=";
  };

  postPatch = ''
    cp ${catch}/include/catch/catch.hpp symengine/utilities/catch/catch.hpp
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  ] ++ lib.optionals withShared [
    "-DBUILD_SHARED_LIBS=ON"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  doCheck = true;

<<<<<<< HEAD
=======
  checkPhase = ''
    ctest
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A fast symbolic manipulation library";
    homepage = "https://github.com/symengine/symengine";
    platforms = platforms.unix ++ platforms.windows;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };

}
