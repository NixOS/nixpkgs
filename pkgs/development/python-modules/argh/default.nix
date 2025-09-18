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
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8wAj2L4Uyl7msbPuq4KRUde72kZK4H3E3VNHkZxYkvk=";
  };

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [
    iocapture
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "argh" ];

  meta = with lib; {
    changelog = "https://github.com/neithere/argh/blob/v${version}/CHANGES";
    homepage = "https://github.com/neithere/argh";
    description = "Unobtrusive argparse wrapper with natural syntax";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
