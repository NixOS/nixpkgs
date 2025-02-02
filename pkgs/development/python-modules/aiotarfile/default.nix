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
    rev = "refs/tags/v${version}";
    hash = "sha256-DslG+XxIYb04I3B7m0fmRmE3hFCczF039QhSVdHGPL8=";
  };
  passthru.updateScript = nix-update-script { };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes."async-tar-0.4.2" = "sha256-C8M/5YEo3OIfN+654pVTfDm8C8qmKX5qy61NKFt7Jb4=";
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

  meta = with lib; {
    description = "Stream-based, asynchronous tarball processing";
    homepage = "https://github.com/rhelmot/aiotarfile";
    changelog = "https://github.com/rhelmot/aiotarfile/commits/v{version}";
    license = licenses.mit;
    maintainers = with maintainers; [ nicoo ];
  };
}
