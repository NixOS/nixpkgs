{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, poetry-core
, urllib3
, requests
}:

buildPythonPackage rec {
  pname = "py-synologydsm-api";
  version = "1.0.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mib1185";
    repo = "synologydsm-api";
    rev = "v${version}";
    sha256 = "1f9fbcp6dbh1c7q1cpppwggnw4m89w14cjdgl64f1bzv72rggpn1";
  };

  nativeBuildInputs = [ poetry-core ];
  propagatedBuildInputs = [ urllib3 requests ];
  pythonImportsCheck = [ "synology_dsm" ];
  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python API for Synology DSM";
    homepage = "https://github.com/hacf-fr/synologydsm-api";
    license = licenses.mit;
    maintainers = with maintainers; [ uvnikita ];
  };
}
