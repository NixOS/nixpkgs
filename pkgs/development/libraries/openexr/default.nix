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
  version = "2.5.7";

  outputs = [ "bin" "dev" "out" "doc" ];

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openexr";
    rev = "v${version}";
    sha256 = "1vja0rbilcd1wn184w8nbcmck00n7bfwlddwiaxw8dhj64nx4468";
  };

  patches = [
    # Fix pkg-config paths
    (fetchpatch {
      url = "https://github.com/AcademySoftwareFoundation/openexr/commit/2f19a01923885fda75ec9d19332de080ec7102bd.patch";
      sha256 = "1yxmrdzq1x1911wdzwnzr29jmg2r4wd4yx3vhjn0y5dpny0ri5y5";
    })
  ];

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ ilmbase zlib ];

  meta = with lib; {
    description = "A high dynamic-range (HDR) image file format";
    homepage = "https://www.openexr.com/";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
