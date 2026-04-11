{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  hatch-vcs,
  installShellFiles,
  pytestCheckHook,
  requests-mock,
  requests,
  pydantic,
  click,
  appdirs,
  stdenv,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "philipstv";
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bcyran";
    repo = "philipstv";
    tag = version;
    hash = "sha256-UJYxQ3R1bEoNkhm5FiFqQC4PbeEqsBKZYdqv5i5H7rg=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  dependencies = [
    requests
    pydantic
    click
    appdirs
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd philipstv \
      --bash <(_PHILIPSTV_COMPLETE=bash_source $out/bin/philipstv) \
      --zsh <(_PHILIPSTV_COMPLETE=zsh_source $out/bin/philipstv) \
      --fish <(_PHILIPSTV_COMPLETE=fish_source $out/bin/philipstv)
  '';

  pythonImportsCheck = [ "philipstv" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI and library to control Philips Android-powered TVs";
    homepage = "https://github.com/bcyran/philipstv";
    changelog = "https://github.com/bcyran/philipstv/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    mainProgram = "philipstv";
    maintainers = with lib.maintainers; [ bcyran ];
  };
}
