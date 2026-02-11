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

buildPythonPackage (finalAttrs: {
  pname = "jsonargparse";
  version = "4.46.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "omni-us";
    repo = "jsonargparse";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YLryV70RV4TH86ysllMXyCsZp7xr1LRFwKU1PjvoilA=";
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

  meta = {
    description = "Module to implement minimal boilerplate CLIs derived from various sources";
    homepage = "https://github.com/omni-us/jsonargparse";
    changelog = "https://github.com/omni-us/jsonargparse/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
