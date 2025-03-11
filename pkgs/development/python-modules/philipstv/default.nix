{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  poetry-core,
  poetry-dynamic-versioning,
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
  version = "2.1.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bcyran";
    repo = "philipstv";
    tag = version;
    hash = "sha256-BvQurZls9NjtHhTXLQ9t8fHkAF/QU/c6mmRvNmE0v90=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
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
    changelog = "https://github.com/bcyran/philipstv/releases/tag/${version}";
    license = lib.licenses.mit;
    mainProgram = "philipstv";
    maintainers = with lib.maintainers; [ bcyran ];
  };
}
