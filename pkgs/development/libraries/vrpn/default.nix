{ stdenv, fetchFromGitHub, unzip, cmake, libGLU_combined }:

stdenv.mkDerivation rec {
  name    = "${pname}-${date}";
  pname   = "vrpn";
  date    = "2016-08-27";

  src = fetchFromGitHub {
    owner  = "vrpn";
    repo   = "vrpn";
    rev    = "9fa0ab3676a43527301c9efd3637f80220eb9462";
    sha256 = "032q295d68w34rk5q8nfqdd29s55n00bfik84y7xzkjrpspaprlh";
  };

  buildInputs = [ unzip cmake libGLU_combined ];

  doCheck = false; # FIXME: test failure
  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "Virtual Reality Peripheral Network";
    longDescription = ''
      The Virtual-Reality Peripheral Network (VRPN) is a set of classes
      within a library and a set of servers that are designed to implement
      a network-transparent interface between application programs and the
      set of physical devices (tracker, etc.) used in a virtual-reality
      (VR) system.
    '';
    homepage    = https://github.com/vrpn/vrpn;
    license     = licenses.boost; # see https://github.com/vrpn/vrpn/wiki/License
    platforms   = platforms.linux;
    maintainers = with maintainers; [ ludo ];
  };
}
