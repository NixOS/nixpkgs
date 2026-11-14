{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bracex";
  version = "3.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-B6myEAzuzAwkr6GhcUv41KartD1ZKTlFX2YraCrJuqQ=";
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
