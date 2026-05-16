{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  ilmbase,
  fetchpatch,
  cmake,
  ctestCheckHook,
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
  ]
  ++ lib.optional stdenv.hostPlatform.isStatic "-DCMAKE_SKIP_RPATH=ON";

  nativeBuildInputs = [ cmake ];
  nativeCheckInputs = [
    ctestCheckHook
  ];
  propagatedBuildInputs = [
    ilmbase
    zlib
  ];

  # https://github.com/AcademySoftwareFoundation/openexr/issues/1400
  # https://github.com/AcademySoftwareFoundation/openexr/issues/1281
  doCheck = !stdenv.hostPlatform.isAarch32 && !stdenv.hostPlatform.isi686;

  disabledTests = lib.optionals (stdenv.hostPlatform.isPower64 && stdenv.hostPlatform.isBigEndian) [
    # https://github.com/AcademySoftwareFoundation/openexr/issues/222
    "OpenEXR.IlmImf"
  ];

  meta = {
    description = "High dynamic-range (HDR) image file format";
    homepage = "https://www.openexr.com/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    knownVulnerabilities = [
      "CVE-2021-3598: ImfDeepScanLineInputFile Out-of-Bounds Read"
      "CVE-2021-3605: rleUncompress Out-of-Bounds Read"
      "CVE-2021-3933: Integer Overflow Vulnerability in File Processing on 32-bit Systems"
      "CVE-2021-23169: copyIntoFrameBuffer Heap Buffer Overflow Leading to Arbitrary Code Execution"
      "CVE-2021-23215: DwaCompressor Integer Overflow Leads to Heap Buffer Overflow"
      "CVE-2021-26260: DwaCompressor Integer Overflow Leading to Heap Buffer Overflow"
      "CVE-2021-26945: Integer Overflow Leading to Heap Buffer Overflow"
      "CVE-2023-5841: Heap Overflow in Scanline Deep Data Parsing"
      "CVE-2024-31047: convert Function Denial of Service"
      "CVE-2025-12495: EXR File Parsing Heap-based Buffer Overflow Remote Code Execution"
      "CVE-2025-12839: EXR File Parsing Heap-based Buffer Overflow Remote Code Execution"
      "CVE-2025-12840: EXR File Parsing Heap-based Buffer Overflow Remote Code Execution"
      "CVE-2026-27622: CompositeDeepScanLine integer-overflow leads to heap OOB write"
    ];
  };
}
