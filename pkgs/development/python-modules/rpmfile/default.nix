{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
}:
buildPythonPackage rec {
  pname = "rpmfile";
  version = "2.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-j/xE0V+NK2ytHqiFsJ4cpfF0RTLCRxBVTz/khzUG6do=";
  };

  # Tests access the internet
  doCheck = false;

  nativeBuildInputs = [ setuptools-scm ];

  pythonImportsCheck = [ "rpmfile" ];

  meta = {
    description = "Read rpm archive files";
    mainProgram = "rpmfile";
    homepage = "https://github.com/srossross/rpmfile";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
