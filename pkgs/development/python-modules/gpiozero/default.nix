{ lib
, buildPythonPackage
, fetchFromGitHub
, sphinx-rtd-theme
, sphinxHook
, colorzero
, mock
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "gpiozero";
  version = "1.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

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

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "gpiozero"
    "gpiozero.tools"
  ];

  disabledTests = [
    # https://github.com/gpiozero/gpiozero/issues/1087
    "test_spi_hardware_write"
  ];

  meta = with lib; {
    description = "A simple interface to GPIO devices with Raspberry Pi";
    homepage = "https://github.com/gpiozero/gpiozero";
    changelog = "https://github.com/gpiozero/gpiozero/blob/v${version}/docs/changelog.rst";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hexa ];
  };
}
