{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  cmake,
}:

buildPythonPackage rec {
  pname = "kuzu";
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9FqgXhoZ5qtNwCwSOdcKGA+Lpzlxorq6zRVmjgZz5KQ=";
  };

  pyproject = true;

  nativeBuildInputs = [
    setuptools-scm
    cmake
  ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "kuzu" ];

  meta = {
    description = "Python bindings for Kuzu, an embeddable property graph database management system";
    homepage = "https://kuzudb.com/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sdht0 ];
  };
}
