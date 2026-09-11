{
  lib,
  asdf-astropy,
  asdf-coordinates-schemas,
  asdf-standard,
  asdf-transform-schemas,
  asdf,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "asdf-wcs-schemas";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asdf-format";
    repo = "asdf-wcs-schemas";
    tag = version;
    hash = "sha256-S9SAQzy+FQ2idNDydYnexb3QJfd6vG/JKYg5z0tjkNo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    asdf-coordinates-schemas
    asdf-standard
    asdf-transform-schemas
  ];

  nativeCheckInputs = [
    asdf
    asdf-astropy
    pytestCheckHook
  ];

  pythonImportsCheck = [ "asdf_wcs_schemas" ];

  meta = {
    description = "World Coordinate System (WCS) ASDF schemas";
    homepage = "https://github.com/asdf-format/asdf-wcs-schemas";
    changelog = "https://github.com/asdf-format/asdf-wcs-schemas/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
