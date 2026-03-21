{
  stdenv,
  buildPythonPackage,
  lib,
  pythonAtLeast,
  fetchPypi,
  poetry-core,
  setuptools,
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
  version = "0.30.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WMNKl4hfW/GIOwHNekZSwguaM64LLerQarEhOgqb2rs=";
  };

  build-system = [
    poetry-core
    setuptools
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

  meta = {
    broken = stdenv.hostPlatform.isDarwin || pythonAtLeast "3.14"; # https://github.com/MolSSI/QCElemental/issues/375
    description = "Periodic table, physical constants and molecule parsing for quantum chemistry";
    homepage = "https://github.com/MolSSI/QCElemental";
    changelog = "https://github.com/MolSSI/QCElemental/blob/v${version}/docs/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sheepforce ];
  };
}
