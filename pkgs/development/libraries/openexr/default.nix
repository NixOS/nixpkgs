{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  ilmbase,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "openexr";
  version = "2.5.10";

  outputs = [
    "bin"
    "dev"
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openexr";
    rev = "v${version}";
    hash = "sha256-xdC+T79ZQBx/XhuIXtP93Roj0N9lF+E65ReEKQ4kIsg=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2021-45942.patch";
      url = "https://github.com/AcademySoftwareFoundation/openexr/commit/11cad77da87c4fa2aab7d58dd5339e254db7937e.patch";
      stripLen = 4;
      extraPrefix = "OpenEXR/IlmImf/";
      sha256 = "1wa2jn6sa0n3phaqvklnlbgk1bz60y756ad4jk4d757pzpnannsy";
    })
    (fetchpatch {
      name = "CVE-2021-3933.patch";
      url = "https://github.com/AcademySoftwareFoundation/openexr/commit/5db6f7aee79e3e75e8c3780b18b28699614dd08e.patch";
      stripLen = 4;
      extraPrefix = "OpenEXR/IlmImf/";
      sha256 = "sha256-DrpldpNgN5pWKzIuuPIrynGX3EpP8YhJlu+lLfNFGxQ=";
    })

    # GCC 13 fixes
    ./gcc-13.patch
  ];

  postPatch = ''
    # tests are determined to use /var/tmp on unix
    find . -name tmpDir.h | while read -r f ; do
      substituteInPlace $f --replace '/var/tmp' "$TMPDIR"
    done
    # On slower machines this test can take more than the default 1500 seconds
    echo 'set_tests_properties(OpenEXR.IlmImf PROPERTIES TIMEOUT 3000)' >> OpenEXR/IlmImfTest/CMakeLists.txt
  '';

  cmakeFlags = [
    "-DCMAKE_CTEST_ARGUMENTS=--timeout;3600"
  ] ++ lib.optional stdenv.hostPlatform.isStatic "-DCMAKE_SKIP_RPATH=ON";

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [
    ilmbase
    zlib
  ];

  # https://github.com/AcademySoftwareFoundation/openexr/issues/1400
  # https://github.com/AcademySoftwareFoundation/openexr/issues/1281
  doCheck = !stdenv.hostPlatform.isAarch32 && !stdenv.hostPlatform.isi686;

  meta = with lib; {
    description = "High dynamic-range (HDR) image file format";
    homepage = "https://www.openexr.com/";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
