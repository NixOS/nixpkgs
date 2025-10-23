{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "asdf-standard";
  version = "1.4.0";
  pyproject = true;

  src = fetchPypi {
    pname = "asdf_standard";
    inherit version;
    hash = "sha256-DF8SHQ24fLd4DWGgh/OSxRBM4ggBbPsqEwyc6pEs/dw=";
  };

  build-system = [ setuptools-scm ];

  # Circular dependency on asdf
  doCheck = false;

  pythonImportsCheck = [ "asdf_standard" ];

  meta = with lib; {
    description = "Standards document describing ASDF";
    homepage = "https://github.com/asdf-format/asdf-standard";
    changelog = "https://github.com/asdf-format/asdf-standard/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
