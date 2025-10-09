{
  lib,
  asdf-standard,
  buildPythonPackage,
  fetchPypi,
  importlib-resources,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "asdf-transform-schemas";
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "asdf_transform_schemas";
    inherit version;
    hash = "sha256-D1D44Jb//S0UucgplZASZu8lsj0N/8MK1Bu6RoUalzI=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ asdf-standard ] ++ lib.optionals (pythonOlder "3.9") [ importlib-resources ];

  # Circular dependency on asdf
  doCheck = false;

  pythonImportsCheck = [ "asdf_transform_schemas" ];

  meta = with lib; {
    description = "ASDF schemas for validating transform tags";
    homepage = "https://github.com/asdf-format/asdf-transform-schemas";
    changelog = "https://github.com/asdf-format/asdf-transform-schemas/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
