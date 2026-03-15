{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  setuptools,

  # dependencies
  pyyaml,

  # optional-dependencies

  # tests

  argcomplete,
  docstring-parser,
  fsspec,
  jsonnet,
  jsonschema,
  omegaconf,
  pytestCheckHook,
  reconplogger,
  requests,
  ruyaml,
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

  optional-dependencies = lib.fix (self: {
    all =
      self.argcomplete
      ++ self.fsspec
      ++ self.jsonnet
      ++ self.jsonschema
      ++ self.omegaconf
      ++ self.reconplogger
      ++ self.ruyaml
      ++ self.signatures
      ++ self.toml
      ++ self.urls;
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
  });

  nativeCheckInputs = [
    pytestCheckHook
    types-pyyaml
    types-requests
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.14") [
    # _pickle.PicklingError: Can't pickle local object ...
    "test_get_argument_group_class_underscores_to_dashes"
    "test_pickle_parser"
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
