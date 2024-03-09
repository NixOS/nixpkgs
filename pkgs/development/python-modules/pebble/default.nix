{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pebble";
  version = "5.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Pebble";
    inherit version;
    hash = "sha256-5/fs/QEHq3zsnzu0EahWxNfVUiAtTpqLA46aZK4x/Yw=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  doCheck = !stdenv.isDarwin;

  pythonImportsCheck = [
    "pebble"
  ];

  meta = with lib; {
    description = "API to manage threads and processes within an application";
    homepage = "https://github.com/noxdafox/pebble";
    changelog = "https://github.com/noxdafox/pebble/releases/tag/${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ orivej ];
  };
}
