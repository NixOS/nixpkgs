{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
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
