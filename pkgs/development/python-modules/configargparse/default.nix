{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "configargparse";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "bw2";
    repo = "ConfigArgParse";
    rev = "v${version}";
    sha256 = "sha256-hzhjrdrXxjksvbHlTnQVsT350g0yuG1F21fElv6bLSA=";
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
