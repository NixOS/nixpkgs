{
  stdenv,
  buildPythonPackage,
  lib,
  fetchPypi,
  poetry-core,
  ipykernel,
  networkx,
  numpy,
  packaging,
  pint,
  pydantic,
  pytestCheckHook,
  pythonOlder,
  scipy,
}:

buildPythonPackage rec {
  pname = "qcelemental";
  version = "0.29.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v2NO5lLn2V6QbikZiVEyJCM7HXBcJq/qyG5FHzFrPAQ=";
  };

  build-system = [ poetry-core ];

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

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Periodic table, physical constants and molecule parsing for quantum chemistry";
    homepage = "https://github.com/MolSSI/QCElemental";
    changelog = "https://github.com/MolSSI/QCElemental/blob/v${version}/docs/changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sheepforce ];
  };
}
