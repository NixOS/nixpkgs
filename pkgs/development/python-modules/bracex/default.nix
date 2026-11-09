{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bracex";
  version = "3.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TjjjI5LkpHgP4V1kS/x8hRQFfPw4YeBgsRgUzoKcJeQ=";
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
