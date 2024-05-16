{
  lib,
  argcomplete,
  attrs,
  buildPythonPackage,
  docstring-parser,
  fetchFromGitHub,
  fsspec,
  jsonnet,
  jsonschema,
  omegaconf,
  pydantic,
  pytest-subtests,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  reconplogger,
  requests,
  responses,
  ruyaml,
  setuptools,
  types-pyyaml,
  types-requests,
  typeshed-client,
}:

buildPythonPackage rec {
  pname = "jsonargparse";
  version = "4.28.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "omni-us";
    repo = "jsonargparse";
    rev = "refs/tags/v${version}";
    hash = "sha256-iw6ntzFkvMg5baOgeUzf3qV1eGGqywINd7e6N781llQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyyaml ];

  passthru.optional-dependencies = {
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
    description = "Module to mplement minimal boilerplate CLIs derived from various sources";
    homepage = "https://github.com/omni-us/jsonargparse";
    changelog = "https://github.com/omni-us/jsonargparse/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
