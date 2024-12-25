{
  lib,
  buildPythonPackage,
  python,
  pythonOlder,
  fetchFromGitHub,
  cmake,
  sip4,
}:

buildPythonPackage rec {
  pname = "libsavitar";
  version = "4.12.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "libSavitar";
    rev = version;
    hash = "sha256-MAA1WtGED6lvU6N4BE6wwY1aYaFrCq/gkmQFz3VWqNA=";
  };

  postPatch = ''
    sed -i 's#''${Python3_SITEARCH}#${placeholder "out"}/${python.sitePackages}#' cmake/SIPMacros.cmake
  '';

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [ sip4 ];

  disabled = pythonOlder "3.4.0";

  meta = with lib; {
    description = "C++ implementation of 3mf loading with SIP python bindings";
    homepage = "https://github.com/Ultimaker/libSavitar";
    license = licenses.lgpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      abbradar
      orivej
      gebner
    ];
  };
}
