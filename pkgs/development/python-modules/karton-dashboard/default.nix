{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, karton-core
, mistune
, networkx
, prometheus-client
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "karton-dashboard";
  version = "1.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-O7Wrl9+RWkHPO0+9aue1Nlv0263qX8Thnh5FmnoKjxU=";
  };

  pythonRelaxDeps = [
    "Flask"
    "mistune"
    "networkx"
    "prometheus-client"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    flask
    karton-core
    mistune
    networkx
    prometheus-client
  ];

  # Project has no tests. pythonImportsCheck requires MinIO configuration
  doCheck = false;

  meta = with lib; {
    description = "Web application that allows for Karton task and queue introspection";
    homepage = "https://github.com/CERT-Polska/karton-dashboard";
    changelog = "https://github.com/CERT-Polska/karton-dashboard/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
