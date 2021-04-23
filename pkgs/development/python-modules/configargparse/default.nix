{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "configargparse";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "bw2";
    repo = "ConfigArgParse";
    rev = "v${version}";
    sha256 = "0x6ar7d8qhr7gb1s8asbhqymg9jd635h7cyczqrbmvm8689zhj1d";
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
