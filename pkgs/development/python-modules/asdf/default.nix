{
  lib,
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
  semantic-version,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "asdf";
  version = "4.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "asdf-format";
    repo = "asdf";
    tag = version;
    hash = "sha256-4fR9hc6Ez6uwi/QwOQwRyRfpbHsmGsJEtWZIj4k+9FY=";
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
    fsspec
    lz4
    psutil
    pytest-remotedata
    pytestCheckHook
  ];

  pythonImportsCheck = [ "asdf" ];

  meta = {
    description = "Python tools to handle ASDF files";
    homepage = "https://github.com/asdf-format/asdf";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
  };
}
