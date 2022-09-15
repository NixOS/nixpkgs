{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, pkg-config
, libebml }:

stdenv.mkDerivation rec {
  pname = "libmatroska";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner  = "Matroska-Org";
    repo   = "libmatroska";
    rev    = "release-${version}";
    sha256 = "01dg12ndxfdqgjx5v2qy4mff6xjdxglywyg82sr3if5aw6rp3dji";
  };

  # in master post 1.6.3, see https://github.com/Matroska-Org/libmatroska/issues/62
  patches = [
    (fetchpatch {
      name = "fix-pkg-config.patch";
      url = "https://github.com/Matroska-Org/libmatroska/commit/53f6ea573878621871bca5f089220229fcb33a3b.patch";
      sha256 = "1lcxl3n32kk5x4aa4ja7p68km7qb2bwscavpv7qdmbhp3w5ia0mk";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libebml ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=YES"
    "-DCMAKE_INSTALL_PREFIX="
  ];

  meta = with lib; {
    description = "A library to parse Matroska files";
    homepage = "https://matroska.org/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ spwhitt ];
    platforms = platforms.unix;
  };
}
