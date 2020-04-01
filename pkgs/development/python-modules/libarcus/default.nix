{ stdenv, buildPythonPackage, python, fetchFromGitHub
, cmake, sip, protobuf, pythonOlder }:

buildPythonPackage rec {
  pname = "libarcus";
  version = "4.5.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "libArcus";
    rev = version;
    sha256 = "1sfy8skvgw6hiihs9jmfn7a13yappqwffir98pahyg7cim7p55kr";
  };

  disabled = pythonOlder "3.4.0";

  propagatedBuildInputs = [ sip ];
  nativeBuildInputs = [ cmake ];
  buildInputs = [ protobuf ];

  postPatch = ''
    sed -i 's#''${Python3_SITEARCH}#${placeholder "out"}/${python.sitePackages}#' cmake/SIPMacros.cmake
  '';

  meta = with stdenv.lib; {
    description = "Communication library between internal components for Ultimaker software";
    homepage = https://github.com/Ultimaker/libArcus;
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar gebner ];
  };
}
