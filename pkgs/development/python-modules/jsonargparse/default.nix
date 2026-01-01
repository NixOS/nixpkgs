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

buildPythonPackage rec {
  pname = "jsonargparse";
<<<<<<< HEAD
  version = "4.45.0";
=======
  version = "4.44.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "omni-us";
    repo = "jsonargparse";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-bp1oQAVlFSNecE2vOyekfA8ij5Pq2PK0fasTIpoKmqs=";
=======
    hash = "sha256-VcCfoWT54/SGPYBOTLJuyX4507HMqwrZMQbUt0sN0Wg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Module to implement minimal boilerplate CLIs derived from various sources";
    homepage = "https://github.com/omni-us/jsonargparse";
    changelog = "https://github.com/omni-us/jsonargparse/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Module to implement minimal boilerplate CLIs derived from various sources";
    homepage = "https://github.com/omni-us/jsonargparse";
    changelog = "https://github.com/omni-us/jsonargparse/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
