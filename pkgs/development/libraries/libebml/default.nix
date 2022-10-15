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
    # in master post 1.4.2, see https://github.com/Matroska-Org/libebml/issues/97
    (fetchpatch {
      name = "fix-pkg-config.patch";
      url = "https://github.com/Matroska-Org/libebml/commit/42fbae35d291b737f2bb4ad5d643fd0d48537a88.patch";
      sha256 = "020qp4a3l60mcm4n310ynxbbv5qlpmybb9xy10pjvx4brp83pmy3";
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
