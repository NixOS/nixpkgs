{ stdenv, buildPythonPackage, fetchFromGitHub
, cmake, sip, protobuf, pythonOlder }:

buildPythonPackage rec {
  pname = "libarcus";
  version = "3.6.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "libArcus";
    rev = version;
    sha256 = "1zbp6axai47k3p2q497wiajls1h17wss143zynbwbwrqinsfiw43";
  };

  disabled = pythonOlder "3.4.0";

  propagatedBuildInputs = [ sip protobuf ];
  nativeBuildInputs = [ cmake ];

  postPatch = ''
    # To workaround buggy SIP detection which overrides PYTHONPATH
    sed -i '/SET(ENV{PYTHONPATH}/d' cmake/FindSIP.cmake
  '';

  meta = with stdenv.lib; {
    description = "Communication library between internal components for Ultimaker software";
    homepage = https://github.com/Ultimaker/libArcus;
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
