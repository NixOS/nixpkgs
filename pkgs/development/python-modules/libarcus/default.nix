{ lib, buildPythonPackage, python, fetchFromGitHub
, cmake, sip, protobuf, pythonOlder }:

buildPythonPackage rec {
  pname = "libarcus";
  version = "4.8.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "libArcus";
    rev = version;
    sha256 = "1dvz1rkvm4309yzvj7vy49v1vskr5yfq4nzqdiydp1jb7zpvhqqm";
  };

  disabled = pythonOlder "3.4.0";

  propagatedBuildInputs = [ sip ];
  nativeBuildInputs = [ cmake ];
  buildInputs = [ protobuf ];

  postPatch = ''
    sed -i 's#''${Python3_SITEARCH}#${placeholder "out"}/${python.sitePackages}#' cmake/SIPMacros.cmake
  '';

  meta = with lib; {
    description = "Communication library between internal components for Ultimaker software";
    homepage = "https://github.com/Ultimaker/libArcus";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar gebner ];
  };
}
