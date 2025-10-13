{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  imath,
  libdeflate,
  pkg-config,
  libjxl,
  pkgsCross,
}:

stdenv.mkDerivation rec {
  pname = "openexr";
  version = "3.3.5";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openexr";
    rev = "v${version}";
    hash = "sha256-J1SButHDPy0gGkVOZKfemaMF0MY/lifB5n39+3GRKR8=";
  };

  outputs = [
    "bin"
    "dev"
    "out"
    "doc"
  ];

  patches =
    # Disable broken test on musl libc
    # https://github.com/AcademySoftwareFoundation/openexr/issues/1556
    lib.optional stdenv.hostPlatform.isMusl ./disable-iex-test.patch;

  # tests are determined to use /var/tmp on unix
  postPatch = ''
    cat <(find . -name tmpDir.h) <(echo src/test/OpenEXRCoreTest/main.cpp) | while read -r f ; do
      substituteInPlace $f --replace '/var/tmp' "$TMPDIR"
    done
  '';

  cmakeFlags = lib.optional stdenv.hostPlatform.isStatic "-DCMAKE_SKIP_RPATH=ON";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  propagatedBuildInputs = [
    imath
    libdeflate
  ];

  # Without 'sse' enforcement tests fail on i686 as due to excessive precision as:
  #   error reading back channel B pixel 21,-76 got -nan expected -nan
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isi686 "-msse2 -mfpmath=sse";

  # https://github.com/AcademySoftwareFoundation/openexr/issues/1400
  doCheck = !stdenv.hostPlatform.isAarch32;

  passthru.tests = {
    inherit libjxl;
    musl = pkgsCross.musl64.openexr;
  };

  meta = with lib; {
    description = "High dynamic-range (HDR) image file format";
    homepage = "https://www.openexr.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ paperdigits ];
    platforms = platforms.all;
  };
}
