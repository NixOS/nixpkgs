{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "loro";
  version = "1.5.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vC1SLkwCkiytZe9d9t1OH+Vd360657XxdU81bM9C9jk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-cjIHU2aMxkYMoulePmxFhuZrqMbnOkEL+Ar75+KCVFw=";
  };

  build-system = [
    rustPlatform.maturinBuildHook
    rustPlatform.cargoSetupHook
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Upstream test has hardcoded version and is rarely updated.
    # See https://github.com/loro-dev/loro-py/issues/19
    "test_version"
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
