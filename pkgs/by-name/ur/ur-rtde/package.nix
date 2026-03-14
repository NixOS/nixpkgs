{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  boost183,
}:

stdenv.mkDerivation rec {
  pname = "ur-rtde";
  version = "1.6.0";

  src = fetchFromGitLab {
    owner = "sdurobotics";
    repo = "ur_rtde";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-Aj/+XVlcjloNctf4lUU2Rb+Zu+GkzckqHdAZGvyIqZQ=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost183 ];

  cmakeFlags = [
    "-DPYTHON_BINDINGS=OFF"
  ];

  meta = with lib; {
    description = "A C++ interface for controlling and receiving data from a UR robot using the Real-Time Data Exchange (RTDE) interface";
    homepage = "https://gitlab.com/sdurobotics/ur_rtde";
    license = licenses.mit;
    maintainers = with maintainers; [ stepisptr-t ];
    platforms = platforms.all;
  };
}
