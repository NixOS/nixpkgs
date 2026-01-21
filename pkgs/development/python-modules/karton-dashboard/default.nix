{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  karton-core,
  mistune,
  networkx,
  prometheus-client,
}:

buildPythonPackage rec {
  pname = "karton-dashboard";
  version = "1.6.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "karton-dashboard";
    tag = "v${version}";
    hash = "sha256-VzBC7IATF8QBtTXMv4vmorAzBlImEsayjenQ2Uz5jIo=";
  };

  pythonRelaxDeps = [
    "Flask"
    "mistune"
    "networkx"
    "prometheus-client"
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

  meta = {
    description = "Web application that allows for Karton task and queue introspection";
    mainProgram = "karton-dashboard";
    homepage = "https://github.com/CERT-Polska/karton-dashboard";
    changelog = "https://github.com/CERT-Polska/karton-dashboard/releases/tag/v${version}";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
