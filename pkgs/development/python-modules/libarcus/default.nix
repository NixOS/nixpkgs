{ lib, buildPythonPackage, python, fetchFromGitHub
, cmake, sip_4, protobuf, pythonOlder }:

buildPythonPackage rec {
  pname = "libarcus";
  version = "4.10.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "libArcus";
    rev = version;
    sha256 = "1ahka8s8fjwymyr7pca7i7h51ikfr35zy4nkzfcjn946x7p0dprf";
  };

  disabled = pythonOlder "3.4.0";

  propagatedBuildInputs = [ sip_4 ];
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
