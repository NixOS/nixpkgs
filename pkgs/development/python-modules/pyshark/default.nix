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
  version = "0.4.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "KimiNewt";
    repo = pname;
    # 0.4.5 was the last release which was tagged
    # https://github.com/KimiNewt/pyshark/issues/541
    rev = "refs/tags/v${version}";
    hash = "sha256-yEpUFihETKta3+Xb8eSyTZ1uSi7ao4OqWzsCgDLLhe8=";
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
    maintainers = with maintainers; [ ];
  };
}
