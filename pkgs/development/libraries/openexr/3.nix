{ lib
, stdenv
, fetchFromGitHub
<<<<<<< HEAD
, cmake
, imath
, libdeflate
, pkg-config
=======
, fetchpatch
, zlib
, cmake
, imath
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "openexr";
<<<<<<< HEAD
  version = "3.2.0";
=======
  version = "3.1.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openexr";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-cV+qgx3WzdotypgpZhVFxzdKAU2rNVw0KWSdkeN0gLk=";
=======
    sha256 = "sha256-Kl+aOA797aZvrvW4ZQNHdSU7YFPieZEzX3aYeaoH6eU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [ "bin" "dev" "out" "doc" ];

<<<<<<< HEAD
  patches =
    # Disable broken test on musl libc
    # https://github.com/AcademySoftwareFoundation/openexr/issues/1556
    lib.optional stdenv.hostPlatform.isMusl ./disable-iex-test.patch
  ;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # tests are determined to use /var/tmp on unix
  postPatch = ''
    cat <(find . -name tmpDir.h) <(echo src/test/OpenEXRCoreTest/main.cpp) | while read -r f ; do
      substituteInPlace $f --replace '/var/tmp' "$TMPDIR"
    done
  '';

  cmakeFlags = lib.optional stdenv.hostPlatform.isStatic "-DCMAKE_SKIP_RPATH=ON";

<<<<<<< HEAD
  nativeBuildInputs = [ cmake pkg-config ];
  propagatedBuildInputs = [ imath libdeflate ];
=======
  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ imath zlib ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Without 'sse' enforcement tests fail on i686 as due to excessive precision as:
  #   error reading back channel B pixel 21,-76 got -nan expected -nan
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isi686 "-msse2 -mfpmath=sse";

<<<<<<< HEAD
  # https://github.com/AcademySoftwareFoundation/openexr/issues/1400
  doCheck = !stdenv.isAarch32;
=======
  doCheck = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A high dynamic-range (HDR) image file format";
    homepage = "https://www.openexr.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ paperdigits ];
    platforms = platforms.all;
  };
}
