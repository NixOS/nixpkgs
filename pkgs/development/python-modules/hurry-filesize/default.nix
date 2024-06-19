{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "hurry-filesize";
  version = "0.9";
  pyproject = true;

  src = fetchPypi {
    pname = "hurry.filesize";
    inherit version;
    hash = "sha256-9TaDKa2++GrM07yUkFIjQLt5JgRVromxpCwQ9jgBuaY=";
  };

  # project has no repo...
  # fix implicit namespaces (PEP 420) warning
  patches = [ ./use-pep-420-implicit-namespace-package.patch ];

  build-system = [ setuptools ];

  pythonImportsCheck = [ "hurry.filesize" ];

  meta = with lib; {
    description = "A simple Python library for human readable file sizes (or anything sized in bytes)";
    homepage = "https://pypi.org/project/hurry.filesize/";
    license = licenses.zpl21;
    maintainers = with maintainers; [ vizid ];
  };
}
