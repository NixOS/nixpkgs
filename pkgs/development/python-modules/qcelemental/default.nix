{
  stdenv,
  buildPythonPackage,
  lib,
  fetchPypi,
  poetry-core,
  networkx,
  numpy,
  pint,
  pydantic,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "qcelemental";
  version = "0.27.1";

  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dlcfIUKAg6yc4S3RXVJ1sKM29E1ZvHY82kjx1CM8/08=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    networkx
    numpy
    pint
    pydantic
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "qcelemental" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Periodic table, physical constants and molecule parsing for quantum chemistry";
    homepage = "https://github.com/MolSSI/QCElemental";
    changelog = "https://github.com/MolSSI/QCElemental/blob/v${version}/docs/changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sheepforce ];
  };
}
