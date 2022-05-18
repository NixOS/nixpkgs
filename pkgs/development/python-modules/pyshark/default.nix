{ lib
, buildPythonPackage
, fetchFromGitHub
, lxml
, packaging
, py
, pytestCheckHook
, pythonOlder
, wireshark-cli
}:

buildPythonPackage rec {
  pname = "pyshark";
  version = "0.4.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "KimiNewt";
    repo = pname;
    # 0.4.5 was the last release which was tagged
    # https://github.com/KimiNewt/pyshark/issues/541
    rev = "8f8f13aba6ae716aa0a48175255063fe542fdc3b";
    hash = "sha256-v9CC9hgTABAiJ0qiFZ/9/zMmHzJXKq3neGtTq/ucnT4=";
  };

  sourceRoot = "${src.name}/src";

  propagatedBuildInputs = [
    py
    lxml
    packaging
  ];

  checkInputs = [
    pytestCheckHook
    wireshark-cli
  ];

  pythonImportsCheck = [
    "pyshark"
  ];

  pytestFlagsArray = [
    "../tests/"
  ];

  meta = with lib; {
    description = "Python wrapper for tshark, allowing Python packet parsing using Wireshark dissectors";
    homepage = "https://github.com/KimiNewt/pyshark/";
    license = licenses.mit;
    maintainers = with maintainers; [ petabyteboy ];
  };
}
