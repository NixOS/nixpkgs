{
  lib,
  fetchFromGitHub,
  nix-update-script,
  buildPythonPackage,
  unittestCheckHook,
  pythonOlder,
  cargo,
  rustc,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "aiotarfile";
  version = "0.5.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rhelmot";
    repo = "aiotarfile";
    tag = "v${version}";
    hash = "sha256-DslG+XxIYb04I3B7m0fmRmE3hFCczF039QhSVdHGPL8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-e3NbFlBQu9QkGnIwqy2OmlQFVHjlfpMVRFWD2ADGGSc=";
  };

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "tests/" ]; # Not sure why it isn't autodiscovered

  pythonImportsCheck = [ "aiotarfile" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Stream-based, asynchronous tarball processing";
    homepage = "https://github.com/rhelmot/aiotarfile";
    changelog = "https://github.com/rhelmot/aiotarfile/commits/v{version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nicoo ];
  };
}
