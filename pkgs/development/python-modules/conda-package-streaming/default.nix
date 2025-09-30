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
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "conda";
    repo = "conda-package-streaming";
    tag = "v${version}";
    hash = "sha256-BfvD+64c9uxBvEJnAuI4MaF0CqS9Gwnqx1Xi+l36Dwo=";
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
