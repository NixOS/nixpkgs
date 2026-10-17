{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "loro";
  version = "1.16.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s+MLjZqtxgBmKs0x6Qrk2puEyYkAIlqgRNTCjBQKEs4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-qBew1JPbuDVqzoeBvKHARhwgnXNkjDBtrXKZU/dfbaY=";
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
    changelog = "https://github.com/loro-dev/loro-py/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dmadisetti
    ];
  };
}
