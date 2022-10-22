{ lib
, buildPythonPackage
, fetchFromGitHub
, sphinx-rtd-theme
, sphinxHook
, colorzero
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "gpiozero";
  version = "1.6.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "gpiozero";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-dmFc3DNTlEajYQ5e8QK2WfehwYwAsWyG2cxKg5ykEaI=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    sphinx-rtd-theme
    sphinxHook
  ];

  propagatedBuildInputs = [
    colorzero
  ];

  pythonImportsCheck = [
    "gpiozero"
    "gpiozero.tools"
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];


  meta = with lib; {
    description = "A simple interface to GPIO devices with Raspberry Pi";
    homepage = "https://github.com/gpiozero/gpiozero";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
