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
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "conda";
    repo = "conda-package-streaming";
    tag = "v${version}";
    hash = "sha256-jrxp5f6rrrdvaT1Oq0l2j+k518LQ3zKi5ADMsKrYwXM=";
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
