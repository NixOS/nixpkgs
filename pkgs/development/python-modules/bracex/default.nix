{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bracex";
  version = "3.2.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0Yl2Fgs7oBpX1cU6XIw6olBu+p4KOmJGclH4K49WP94=";
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
