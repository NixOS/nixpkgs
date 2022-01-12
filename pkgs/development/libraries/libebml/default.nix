{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, pkg-config }:

stdenv.mkDerivation rec {
  pname = "libebml";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner  = "Matroska-Org";
    repo   = "libebml";
    rev    = "release-${version}";
    sha256 = "1hiilnabar826lfxsaflqjhgsdli6hzzhjv8q2nmw36fvvlyks25";
  };

  patches = [
    # Upstream fix for gcc-11
    (fetchpatch {
      url = "https://github.com/Matroska-Org/libebml/commit/f0bfd53647961e799a43d918c46cf3b6bff89806.patch";
      sha256 = "1yd6rsds03kwx5jki4hihd2bpfh26g5l1pi82qzaqzarixdxwzvl";
      excludes = [ "ChangeLog" ];
    })
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=YES"
    "-DCMAKE_INSTALL_PREFIX="
  ];

  meta = with lib; {
    description = "Extensible Binary Meta Language library";
    homepage = "https://dl.matroska.org/downloads/libebml/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ spwhitt ];
    platforms = platforms.unix;
  };
}
