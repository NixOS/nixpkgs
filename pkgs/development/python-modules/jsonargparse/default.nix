{
  lib,
  argcomplete,
  buildPythonPackage,
  docstring-parser,
  fetchFromGitHub,
  fsspec,
  jsonnet,
  jsonschema,
  omegaconf,
  pytest-subtests,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  reconplogger,
  requests,
  ruyaml,
  setuptools,
  toml,
  types-pyyaml,
  types-requests,
  typeshed-client,
}:

buildPythonPackage rec {
  pname = "jsonargparse";
  version = "4.42.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "omni-us";
    repo = "jsonargparse";
    tag = "v${version}";
    hash = "sha256-M6CEUDf6JcjZWRBoHfVyFmX9ZV8xsB7illoBk0YzZs0=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyyaml ];

  optional-dependencies = {
    all = [
      argcomplete
      fsspec
      jsonnet
      jsonschema
      omegaconf
      ruyaml
      docstring-parser
      typeshed-client
      requests
    ];
    argcomplete = [ argcomplete ];
    fsspec = [ fsspec ];
    jsonnet = [
      jsonnet
      # jsonnet-binary
    ];
    jsonschema = [ jsonschema ];
    omegaconf = [ omegaconf ];
    reconplogger = [ reconplogger ];
    ruyaml = [ ruyaml ];
    signatures = [
      docstring-parser
      typeshed-client
    ];
    toml = [ toml ];
    urls = [ requests ];
  };

  nativeCheckInputs = [
    pytest-subtests
    pytestCheckHook
    types-pyyaml
    types-requests
  ];

  pythonImportsCheck = [ "jsonargparse" ];

  meta = with lib; {
    description = "Module to implement minimal boilerplate CLIs derived from various sources";
    homepage = "https://github.com/omni-us/jsonargparse";
    changelog = "https://github.com/omni-us/jsonargparse/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
