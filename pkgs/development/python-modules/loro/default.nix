{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "loro";
  version = "1.8.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0i3BfL7GUu2L9if4AaCjLieoe0R2oquW9FoC0WPXM64=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-pJJiwLHh10G9L+NZhxcCif2OP1cpjyNCaeG28YyYxmM=";
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
