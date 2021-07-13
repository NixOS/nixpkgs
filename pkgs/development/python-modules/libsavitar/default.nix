{ lib, buildPythonPackage, python, pythonOlder, fetchFromGitHub, cmake, sip_4 }:

buildPythonPackage rec {
  pname = "libsavitar";
  version = "4.10.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "libSavitar";
    rev = version;
    sha256 = "1zyzsrdm5aazv12h7ga35amfryrbxdsmx3abvh27hixyh9f92fdp";
  };

  postPatch = ''
    sed -i 's#''${Python3_SITEARCH}#${placeholder "out"}/${python.sitePackages}#' cmake/SIPMacros.cmake
  '';

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [ sip_4 ];

  disabled = pythonOlder "3.4.0";

  meta = with lib; {
    description = "C++ implementation of 3mf loading with SIP python bindings";
    homepage = "https://github.com/Ultimaker/libSavitar";
    license = licenses.lgpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar orivej gebner ];
  };
}
