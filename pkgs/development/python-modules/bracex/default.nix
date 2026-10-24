{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bracex";
  version = "3.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Cj1Av65MquTTv9DqcVh0eZ+rcRw4/UASzDU0PoFUBc0=";
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
