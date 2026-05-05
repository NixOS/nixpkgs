{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  # dependencies
  bleak,
  prompt-toolkit,
  pycryptodome,
  requests,
  meshcore,
}:

buildPythonPackage (finalAttrs: {
  pname = "meshcore-cli";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meshcore-dev";
    repo = "meshcore-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z8k8m6exl5+Fiz7QncN/isG3cQZt17Vb/ruXzPZAMoo=";
  };

  build-system = [ hatchling ];

  dependencies = [
    bleak
    prompt-toolkit
    pycryptodome
    requests
    meshcore
  ];

  pythonImportsCheck = [ "meshcore_cli" ];

  meta = {
    description = "Command line interface to meshcore companion radios and repeaters";
    homepage = "https://github.com/meshcore-dev/meshcore-cli";
    changelog = "https://github.com/meshcore-dev/meshcore-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "meshcore-cli";
    maintainers = with lib.maintainers; [ robertjakub ];
  };
})
