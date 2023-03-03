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
  ];

  cmakeFlags = lib.optional stdenv.hostPlatform.isStatic "-DCMAKE_SKIP_RPATH=ON";

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ ilmbase zlib ];

  meta = with lib; {
    description = "A high dynamic-range (HDR) image file format";
    homepage = "https://www.openexr.com/";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
