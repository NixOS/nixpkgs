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
  version = "1.0.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mib1185";
    repo = "synologydsm-api";
    rev = "v${version}";
    sha256 = "sha256-jAdD6FCbsBocJNX7o+dpthgHaPLIueFWJMzBNoKAq7w=";
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
