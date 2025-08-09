{
  lib,
  stdenv,
  fetchFromGitHub,
  unzip,
  cmake,
  libGLU,
  libGL,
}:

stdenv.mkDerivation rec {
  pname = "vrpn";
  version = "07.36";

  src = fetchFromGitHub {
    owner = "vrpn";
    repo = "vrpn";
    rev = "version_${version}";
    hash = "sha256-eXmj9Wqm+ytsnypC+MrOLnJg9zlri5y0puavamZqFmY=";
  };

  nativeBuildInputs = [
    cmake
    unzip
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libGLU
    libGL
  ];

  meta = with lib; {
    description = "Virtual Reality Peripheral Network";
    longDescription = ''
      The Virtual-Reality Peripheral Network (VRPN) is a set of classes
      within a library and a set of servers that are designed to implement
      a network-transparent interface between application programs and the
      set of physical devices (tracker, etc.) used in a virtual-reality
      (VR) system.
    '';
    homepage = "https://github.com/vrpn/vrpn";
    license = licenses.boost; # see https://github.com/vrpn/vrpn/wiki/License
    platforms = platforms.darwin ++ platforms.linux;
    maintainers = with maintainers; [ ludo ];
  };
}
