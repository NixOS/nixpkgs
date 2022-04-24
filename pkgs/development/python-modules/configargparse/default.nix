{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "configargparse";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "bw2";
    repo = "ConfigArgParse";
    rev = "v${version}";
    sha256 = "1dsai4bilkp2biy9swfdx2z0k4akw4lpvx12flmk00r80hzgbglz";
  };

  checkInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "configargparse" ];

  meta = with lib; {
    description = "A drop-in replacement for argparse";
    homepage = "https://github.com/bw2/ConfigArgParse";
    license = licenses.mit;
    maintainers = [ maintainers.willibutz ];
  };
}
