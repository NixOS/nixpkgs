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
  version = "3.4.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "asdf-format";
    repo = "asdf";
    rev = "refs/tags/${version}";
    hash = "sha256-2ugrByX2eSac68RGc4mhPiYP8qnYoPwbhrMmvUr2FYg=";
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

  meta = with lib; {
    description = "Python tools to handle ASDF files";
    homepage = "https://github.com/asdf-format/asdf";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
