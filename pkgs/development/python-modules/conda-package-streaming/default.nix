{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  requests,
  zstandard,
}:
buildPythonPackage rec {
  pname = "conda-package-streaming";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "conda";
    repo = "conda-package-streaming";
    rev = "v${version}";
    hash = "sha256-UTql2M+9eFDuHOwLYYKJ751wEcOfLJYzfU6+WF8Je2g=";
  };

  build-system = [ flit-core ];
  dependencies = [
    requests
    zstandard
  ];

  pythonImportsCheck = [ "conda_package_streaming" ];

  meta = {
    description = "Efficient library to read from new and old format .conda and .tar.bz2 conda packages";
    homepage = "https://github.com/conda/conda-package-streaming";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.ericthemagician ];
  };
}
