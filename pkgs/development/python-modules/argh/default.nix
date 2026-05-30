{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  iocapture,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "argh";
  version = "0.31.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8wAj2L4Uyl7msbPuq4KRUde72kZK4H3E3VNHkZxYkvk=";
  };

  patches = [
    # python3.14 introduced a breaking change which caused a test to fail. A
    # fix has been commited upstream in a pull request by the author, but has
    # since been kept unmerged
    # https://github.com/neithere/argh/pull/240
    ./pr240-699568ad-06-01-2025-test_integration.patch
  ];

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [
    iocapture
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "argh" ];

  meta = {
    changelog = "https://github.com/neithere/argh/blob/v${version}/CHANGES";
    homepage = "https://github.com/neithere/argh";
    description = "Unobtrusive argparse wrapper with natural syntax";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
  };
}
