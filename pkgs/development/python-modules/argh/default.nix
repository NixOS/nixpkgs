{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, iocapture
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "argh";
  version = "0.27.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AMkCf29GG88kr+WZooG72ly9Xe5LZwW+++opOkyn0iE=";
  };

  nativeCheckInputs = [
    iocapture
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "argh" ];

  meta = with lib; {
    changelog = "https://github.com/neithere/argh/blob/v${version}/CHANGES";
    homepage = "https://github.com/neithere/argh";
    description = "An unobtrusive argparse wrapper with natural syntax";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ domenkozar ];
  };
}
