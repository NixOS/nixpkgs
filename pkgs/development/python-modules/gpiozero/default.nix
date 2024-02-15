{ lib
, buildPythonPackage
, fetchFromGitHub
, sphinx-rtd-theme
, sphinxHook
, colorzero
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "gpiozero";
  version = "2.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "gpiozero";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-6qSB9RMypNXNj+Ds1nyzB7iaeHXvF0swSubrJSn2L34=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov" ""
  '';

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
