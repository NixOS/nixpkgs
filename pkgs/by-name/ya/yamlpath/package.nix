{
  lib,
  fetchFromGitHub,
  hiera-eyaml,
  python3Packages,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "yamlpath";
  version = "3.9.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "wwkimball";
    repo = "yamlpath";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g6DCm2m4521xACWZ6D/HjaWKthSxlNeUocNnUNArWRk=";
  };

  propagatedBuildInputs = with python3Packages; [
    python-dateutil
    ruamel-yaml
  ];

  nativeCheckInputs = with python3Packages; [
    hiera-eyaml
    mock
    pytest-console-scripts
    pytestCheckHook
  ];

  preCheck = ''
    export PATH=$PATH:$out/bin
  '';

  pythonImportsCheck = [
    "yamlpath"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line processors for YAML/JSON/Compatible data";
    homepage = "https://github.com/wwkimball/yamlpath";
    changelog = "https://github.com/wwkimball/yamlpath/releases/tag/v${finalAttrs.version}";
    longDescription = ''
      Command-line get/set/merge/validate/scan/convert/diff processors for YAML/JSON/Compatible data
      using powerful, intuitive, command-line friendly syntax
    '';
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ drupol ];
  };
})
