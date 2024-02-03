{ lib, buildPythonPackage, fetchFromGitHub, pygobject3, dbus, hatchling, pytestCheckHook }:

buildPythonPackage rec {
  pname = "dasbus";
  version = "unstable-11-10-2022";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "rhinstaller";
    repo = pname;
    rev = "64b6b4d9e37cd7e0cbf4a7bf75faa7cdbd01086d";
    hash = "sha256-TmhhDrfpP+nUErAd7dUb+RtGBRtWwn3bYOoIqa0VRoc=";
  };

  nativeBuildInputs = [ hatchling ];
  propagatedBuildInputs = [ pygobject3 ];
  nativeCheckInputs = [ dbus pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/rhinstaller/dasbus";
    description = "DBus library in Python3";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ moni ];
  };
}
