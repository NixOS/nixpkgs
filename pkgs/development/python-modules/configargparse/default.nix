{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "configargparse";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "bw2";
    repo = "ConfigArgParse";
    rev = version;
    sha256 = "1hgd0gfxycfnlddwsr8sl6ybxzp8rqhin16vphbl8q32wp5hhjd2";
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
