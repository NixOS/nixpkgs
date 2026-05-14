{
  stdenv,
  buildPythonPackage,
  lib,
  pythonAtLeast,
  fetchPypi,
  poetry-core,
  setuptools,
  setuptools-scm,
  ipykernel,
  networkx,
  numpy,
  packaging,
  pint,
  pydantic,
  pytestCheckHook,
  scipy,
}:

buildPythonPackage rec {
  pname = "qcelemental";
  version = "0.50.0rc3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-caQmd7zoDzyd4YT9c5J/7oz2eEbhWpirgZHcnOTwz7k=";
  };

  build-system = [
    poetry-core
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    packaging
    pint
    pydantic
  ];

  optional-dependencies = {
    viz = [
      # TODO: nglview
      ipykernel
    ];
    align = [
      networkx
      scipy
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "qcelemental" ];

  # These tests require network access
  disabledTestPaths = [
    "qcelemental/tests/test_gph_uno_bipartite.py"
    "qcelemental/tests/test_model_general.py"
    "qcelemental/tests/test_model_results.py"
    "qcelemental/tests/test_molecule.py"
    "qcelemental/tests/test_molparse_align_chiral.py"
    "qcelemental/tests/test_molparse_from_schema.py"
    "qcelemental/tests/test_molparse_from_string.py"
    "qcelemental/tests/test_molparse_pubchem.py"
    "qcelemental/tests/test_molparse_to_schema.py"
    "qcelemental/tests/test_molparse_to_string.py"
    "qcelemental/tests/test_molutil.py"
    "qcelemental/tests/test_utils.py"
    "qcelemental/tests/test_zqcschema.py"
  ];

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Periodic table, physical constants and molecule parsing for quantum chemistry";
    homepage = "https://github.com/MolSSI/QCElemental";
    changelog = "https://github.com/MolSSI/QCElemental/blob/v${version}/docs/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sheepforce ];
  };
}
