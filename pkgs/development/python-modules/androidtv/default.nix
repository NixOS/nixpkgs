{ lib
, adb-shell
, aiofiles
, buildPythonPackage
, fetchFromGitHub
, mock
, pure-python-adb
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "androidtv";
  version = "0.0.68";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JeffLIrion";
    repo = "python-androidtv";
    rev = "v${version}";
    hash = "sha256-cRupsdHpzzxV57ZsuWqZBvtbMYWwXFSVLqsNJ7kfpPA=";
  };

  propagatedBuildInputs = [
    adb-shell
    pure-python-adb
  ];

  passthru.optional-dependencies = {
    async = [
      aiofiles
    ];
    inherit (adb-shell.optional-dependencies) usb;
  };

  checkInputs = [
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
