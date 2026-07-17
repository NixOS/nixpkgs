{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nanoid,
  rustPlatform,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastnanoid";
  version = "0.4.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "oliverlambson";
    repo = "fastnanoid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RQg+Srv/wi1mfRel746UwLTAL22uAt0DJBlXlV9p8dE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-d/BoEl9xfo4+5H+8xQxacpmadAJXlV+92yiKlgoERtk=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  nativeCheckInputs = [
    nanoid
    pytestCheckHook
  ];

  # Skip python/ here as it shadows installed fastnanoid
  # pytest puts python/ on sys.path so the source tree is imported first
  enabledTestPaths = [
    "benchmarks"
    "tests"
  ];

  pythonImportsCheck = [ "fastnanoid" ];

  meta = {
    description = "Tiny, secure URL-friendly, and fast unique string ID generator for Python, written in Rust";
    homepage = "https://github.com/oliverlambson/fastnanoid";
    changelog = "https://github.com/oliverlambson/fastnanoid/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aaravrav ];
  };
})
