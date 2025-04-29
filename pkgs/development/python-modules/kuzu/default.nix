{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  cmake,
}:

buildPythonPackage rec {
  pname = "kuzu";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Llnz1NH8OF6ekNeuCfBy7C9M/v9QhYJSOgA0zrB29us=";
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
