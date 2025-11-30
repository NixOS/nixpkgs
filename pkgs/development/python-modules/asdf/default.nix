{
  lib,
  aiohttp,
  asdf-standard,
  asdf-transform-schemas,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  fsspec,
  importlib-metadata,
  jmespath,
  lz4,
  numpy,
  packaging,
  psutil,
  pytest-remotedata,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  requests,
  semantic-version,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "asdf";
  version = "4.3.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "asdf-format";
    repo = "asdf";
    tag = version;
    hash = "sha256-sCjDZ/6KiFH9LbdDpco8z1xRgJe0dm0HVhpRbO51RDI=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    asdf-standard
    asdf-transform-schemas
    importlib-metadata
    jmespath
    numpy
    packaging
    pyyaml
    semantic-version
    attrs
  ];

  nativeCheckInputs = [
    aiohttp
    fsspec
    lz4
    psutil
    pytest-remotedata
    pytestCheckHook
    requests
  ];

  disabledTests = [
    # AssertionError: assert 527033 >= 1048801
    "test_update_add_array_at_end"
  ];

  pythonImportsCheck = [ "asdf" ];

  meta = with lib; {
    description = "Python tools to handle ASDF files";
    homepage = "https://github.com/asdf-format/asdf";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
