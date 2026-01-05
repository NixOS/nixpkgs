{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "xdgcpp";
  version = "0-unstable-2024-05-26";

  src = fetchFromGitHub {
    owner = "Grumbel";
    repo = "xdgcpp";
    rev = "e2c40c081e2ee2d315d1d0b3ae5981d5fd77260e";
    sha256 = "sha256-eujYRUw8UpDFgEvjHUPsJ/QJN+A+hzcebfgteM9kvXM=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Implementation of the XDG Base Directory Specification in C++";
    maintainers = [ lib.maintainers.SchweGELBin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl3;
  };
}
