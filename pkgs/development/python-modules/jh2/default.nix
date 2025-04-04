{
  lib,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  hypothesis,
  pytestCheckHook,
  pythonOlder,
  rustc,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "jh2";
  version = "5.0.8";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "jawah";
    repo = "h2";
    tag = "v${version}";
    hash = "sha256-dQ0FqiX9IqgF8fz0JDWQSHQrr9H3UwG9+mkZI3DwWSU=";
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-P27BIsloNsHHej8qE8EDtXLVvnUmWcbb/6LhP2w7wrw=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "jh2" ];

  meta = {
    description = "HTTP/2 State-Machine based protocol implementation";
    homepage = "https://github.com/jawah/h2";
    changelog = "https://github.com/jawah/h2/blob/${src.rev}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      techknowlogick
    ];
  };
}
