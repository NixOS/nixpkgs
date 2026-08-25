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

buildPythonPackage (finalAttrs: {
  pname = "qcelemental";
  version = "0.51.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-uoEDOwQM4xNvbDWlkqirE/7kUTtNfp7XAHS+DWTy6pc=";
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

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

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
    "qcelemental/tests/test_molparse_mae.py"
    "qcelemental/tests/test_molparse_pubchem.py"
    "qcelemental/tests/test_molparse_to_schema.py"
    "qcelemental/tests/test_molparse_to_string.py"
    "qcelemental/tests/test_molutil.py"
    "qcelemental/tests/test_utils.py"
    "qcelemental/tests/test_zqcschema.py"
  ];

  meta = {
    description = "Periodic table, physical constants and molecule parsing for quantum chemistry";
    homepage = "https://github.com/MolSSI/QCElemental";
    changelog = "https://github.com/MolSSI/QCElemental/blob/v${finalAttrs.version}/docs/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sheepforce ];
  };
})
