{ lib
, stdenv
, fetchFromGitHub
, cmake
, imath
, libdeflate
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "openexr";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openexr";
    rev = "v${version}";
    hash = "sha256-cV+qgx3WzdotypgpZhVFxzdKAU2rNVw0KWSdkeN0gLk=";
  };

  outputs = [ "bin" "dev" "out" "doc" ];

  patches =
    # Disable broken test on musl libc
    # https://github.com/AcademySoftwareFoundation/openexr/issues/1556
    lib.optional stdenv.hostPlatform.isMusl ./disable-iex-test.patch
  ;

  # tests are determined to use /var/tmp on unix
  postPatch = ''
    cat <(find . -name tmpDir.h) <(echo src/test/OpenEXRCoreTest/main.cpp) | while read -r f ; do
      substituteInPlace $f --replace '/var/tmp' "$TMPDIR"
    done
  '';

  cmakeFlags = lib.optional stdenv.hostPlatform.isStatic "-DCMAKE_SKIP_RPATH=ON";

  nativeBuildInputs = [ cmake pkg-config ];
  propagatedBuildInputs = [ imath libdeflate ];

  # Without 'sse' enforcement tests fail on i686 as due to excessive precision as:
  #   error reading back channel B pixel 21,-76 got -nan expected -nan
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isi686 "-msse2 -mfpmath=sse";

  # https://github.com/AcademySoftwareFoundation/openexr/issues/1400
  doCheck = !stdenv.isAarch32;

  meta = with lib; {
    description = "A high dynamic-range (HDR) image file format";
    homepage = "https://www.openexr.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ paperdigits ];
    platforms = platforms.all;
  };
}
