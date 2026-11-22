{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "nh3";
  version = "0.3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "messense";
    repo = "nh3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ta3si1wiRmKQbpbDiu7+WM2pa1AfK3pYSd+Hf8xL5ss=";
  };

  build-system = with rustPlatform; [
    maturinBuildHook
    cargoSetupHook
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-Fp8DaZp5LdaqPH9HUExxdjSJlM0IkkkZn0Owc4k4G0c=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "nh3" ];

  meta = {
    description = "Python binding to Ammonia HTML sanitizer Rust crate";
    homepage = "https://github.com/messense/nh3";
    changelog = "https://github.com/messense/nh3/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      happysalada
      erictapen
    ];
  };
})
