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
  version = "1.7.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "karton-dashboard";
    tag = "v${version}";
    hash = "sha256-DYfL//i1gJ0ci7jVPtrMKC8j+i5/L8rvmbs8zz6Eq2M=";
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
