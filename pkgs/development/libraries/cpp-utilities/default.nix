{ stdenv
, lib
, fetchFromGitHub
, cmake
, cppunit
, iconv
}:

stdenv.mkDerivation rec {
  pname = "cpp-utilities";
<<<<<<< HEAD
  version = "5.24.0";
=======
  version = "5.22.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-krskfuoCRxYcAIDqrae4+yEABXXZ9Nv0BjBVwSMjC7g=";
=======
    sha256 = "sha256-c36FzKDAaalKVIrqVSCoslrKVopW77cGdGwfiMbaXe4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];
  nativeCheckInputs = [ cppunit ];
  buildInputs = lib.optionals stdenv.isDarwin [
    iconv # needed on Darwin, see https://github.com/Martchus/cpp-utilities/issues/4
  ];
<<<<<<< HEAD

  cmakeFlags = ["-DBUILD_SHARED_LIBS=ON"];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # Otherwise, tests fail since the resulting shared object libc++utilities.so is only available in PWD of the make files
  preCheck = ''
    checkFlagsArray+=(
      "LD_LIBRARY_PATH=$PWD"
    )
  '';
  # tests fail on Darwin
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    homepage = "https://github.com/Martchus/cpp-utilities";
    description = "Common C++ classes and routines used by @Martchus' applications featuring argument parser, IO and conversion utilities";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
