{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, zlib
, cmake
, imath
}:

stdenv.mkDerivation rec {
  pname = "openexr";
  version = "3.1.2";

  outputs = [ "bin" "dev" "out" "doc" ];

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openexr";
    rev = "v${version}";
    sha256 = "0vyclrrikphwkkpyjg8kzh3qzflzk3d6xsidgqllgfdgllr9wmgv";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2021-45942.patch";
      url = "https://github.com/AcademySoftwareFoundation/openexr/commit/11cad77da87c4fa2aab7d58dd5339e254db7937e.patch";
      sha256 = "1qa8662ga5i0lyfi9mkj9s9bygdg7h1i6ahki28c664kxrlsakch";
    })
  ];

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ imath zlib ];

  meta = with lib; {
    description = "A high dynamic-range (HDR) image file format";
    homepage = "https://www.openexr.com/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ paperdigits ];
    platforms = platforms.all;
  };
}
