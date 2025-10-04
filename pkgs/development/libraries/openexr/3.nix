{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ctestCheckHook,
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
  nativeCheckInputs = [
    ctestCheckHook
  ];

  # Without 'sse' enforcement tests fail on i686 as due to excessive precision as:
  #   error reading back channel B pixel 21,-76 got -nan expected -nan
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isi686 "-msse2 -mfpmath=sse";

  # https://github.com/AcademySoftwareFoundation/openexr/issues/1400
  doCheck = !stdenv.hostPlatform.isAarch32;

  disabledTests = lib.optionals stdenv.hostPlatform.isBigEndian [
    # https://github.com/AcademySoftwareFoundation/openexr/issues/1175
    # Not sure if these issues are specific to the tests, or if openexr in general is borked on big-endian.
    # Optimistically assuming the former here.
    "OpenEXRCore.testReadDeep"
    "OpenEXRCore.testDWATable"
    "OpenEXRCore.testDWAACompression"
    "OpenEXRCore.testDWABCompression"
    "OpenEXR.testAttributes"
    "OpenEXR.testCompression"
    "OpenEXR.testRgba"
    "OpenEXR.testCRgba"
    "OpenEXR.testRgbaThreading"
    "OpenEXR.testSampleImages"
    "OpenEXR.testSharedFrameBuffer"
    "OpenEXR.testTiledRgba"
  ];

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
