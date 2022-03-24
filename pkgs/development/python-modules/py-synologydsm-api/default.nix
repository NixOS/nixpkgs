{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, requests
, urllib3
}:

buildPythonPackage rec {
  pname = "py-synologydsm-api";
  version = "1.0.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mib1185";
    repo = "synologydsm-api";
    rev = "v${version}";
    sha256 = "sha256-VhAzR/knvun6hJj8/YREqMfNvOKpTyYNI9fk9hsbHDQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    requests
    urllib3
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "synology_dsm"
  ];

  meta = with lib; {
    description = "Python API for Synology DSM";
    homepage = "https://github.com/hacf-fr/synologydsm-api";
    license = licenses.mit;
    maintainers = with maintainers; [ uvnikita ];
  };
}
