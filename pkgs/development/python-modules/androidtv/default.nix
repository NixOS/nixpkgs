{ lib
, adb-shell
, aiofiles
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, mock
, pure-python-adb
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "androidtv";
  version = "0.0.72";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JeffLIrion";
    repo = "python-androidtv";
    rev = "v${version}";
    hash = "sha256-oDC5NWmdo6Ijxz2ER9CjtCZxWkancUNyxVe2ofH4c+Q=";
  };

  propagatedBuildInputs = [
    adb-shell
    async-timeout
    pure-python-adb
  ];

  passthru.optional-dependencies = {
    async = [
      aiofiles
    ];
    inherit (adb-shell.optional-dependencies) usb;
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ]
  ++ passthru.optional-dependencies.async
  ++ passthru.optional-dependencies.usb;

  disabledTests = [
    # Requires git but fails anyway
    "test_no_underscores"
  ];

  pythonImportsCheck = [
    "androidtv"
  ];

  meta = with lib; {
    description = "Communicate with an Android TV or Fire TV device via ADB over a network";
    homepage = "https://github.com/JeffLIrion/python-androidtv/";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
