{ lib
, stdenv
, fetchFromGitHub
, zlib
, ilmbase
, fetchpatch
, cmake
}:

stdenv.mkDerivation rec {
  pname = "openexr";
  version = "2.5.8";

  outputs = [ "bin" "dev" "out" "doc" ];

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openexr";
    rev = "v${version}";
    sha256 = "sha256-N7XdDaDsYdx4TXvHplQDTvhHNUmW5rntdaTKua4C0es=";
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

    # Backport gcc-13 fix:
    #   https://github.com/AcademySoftwareFoundation/openexr/pull/1264
    ./gcc-13.patch
  ];

  # tests are determined to use /var/tmp on unix
  postPatch = ''
    find . -name tmpDir.h | while read -r f ; do
      substituteInPlace $f --replace '/var/tmp' "$TMPDIR"
    done
  '';

  cmakeFlags = lib.optional stdenv.hostPlatform.isStatic "-DCMAKE_SKIP_RPATH=ON";

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ ilmbase zlib ];

  # https://github.com/AcademySoftwareFoundation/openexr/issues/1400
  # https://github.com/AcademySoftwareFoundation/openexr/issues/1281
  doCheck = !stdenv.isAarch32 && !stdenv.isi686;

  meta = with lib; {
    description = "A high dynamic-range (HDR) image file format";
    homepage = "https://www.openexr.com/";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
