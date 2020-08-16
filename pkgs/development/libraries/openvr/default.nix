{ stdenv, fetchFromGitHub, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "openvr";
  version = "1.12.5";

  src = fetchFromGitHub {
    owner = "ValveSoftware";
    repo = "openvr";
    rev = "v${version}";
    sha256 = "1v85qrhgdrmzall4f533l8qw5fbjkkkgw99dmj78hwnz5jbk4rd2";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    description = "OpenVR SDK";
    longDescription = ''
      OpenVR is an API and runtime that allows access to VR hardware from multiple vendors
      without requiring that applications have specific knowledge of the hardware they are
      targeting. This repository is an SDK that contains the API and samples. The runtime
      is under SteamVR in Tools on Steam.
    '';
    license = licenses.bsd3;
    homepage = "http://steamvr.com";
    platforms = platforms.linux;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
