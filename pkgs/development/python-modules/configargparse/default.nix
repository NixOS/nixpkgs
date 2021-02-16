{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ConfigArgParse";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "bw2";
    repo = pname;
    rev = version;
    sha256 = "147x781lgahn9r3gbhayhx1pf0iysf7q1hnr3kypy3p2k9v7a9mh";
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
