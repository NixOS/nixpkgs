{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "loro";
  version = "1.10.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aBhKscKrlK9q1Kq6QW0i9XnKvuCybLsJofZ4WCB7vOg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-Lp4VwxmYqB2uvCuxX+tHl0QCpbCvPMjgrgPk0KL1LEQ=";
  };

  build-system = [
    rustPlatform.maturinBuildHook
    rustPlatform.cargoSetupHook
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Data collaborative and version-controlled JSON with CRDTs";
    homepage = "https://github.com/loro-dev/loro-py";
    changelog = "https://github.com/loro-dev/loro-py/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dmadisetti
    ];
  };
}
