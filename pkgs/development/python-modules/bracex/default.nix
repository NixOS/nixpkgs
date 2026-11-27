{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bracex";
  version = "3.2.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-weZ+tZ+BRF3uFbLFiLfIE1K2l8+9bEkxopQ+prceteo=";
  };

  nativeBuildInputs = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bracex" ];

  meta = {
    description = "Bash style brace expansion for Python";
    homepage = "https://github.com/facelessuser/bracex";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
