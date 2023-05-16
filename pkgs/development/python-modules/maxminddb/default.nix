<<<<<<< HEAD
{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, libmaxminddb
, pytestCheckHook
, pythonOlder
=======
{ stdenv
, lib
, buildPythonPackage
, pythonOlder
, pythonAtLeast
, fetchPypi
, libmaxminddb
, mock
, nose
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "maxminddb";
<<<<<<< HEAD
  version = "2.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-geVOU0CL1QJlDllpzLoWeAr2WewdscRLLJl+QzCl7ZY=";
  };

  buildInputs = [
    libmaxminddb
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "maxminddb"
  ];

  # The multiprocessing tests fail on Darwin because multiprocessing uses spawn instead of fork,
  # resulting in an exception when it can’t pickle the `lookup` local function.
  disabledTests = lib.optionals stdenv.isDarwin [ "multiprocessing" ];
=======
  version = "2.2.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e37707ec4fab115804670e0fb7aedb4b57075a8b6f80052bdc648d3c005184e5";
  };

  buildInputs = [ libmaxminddb ];

  nativeCheckInputs = [ nose mock ];

  # Tests are broken for macOS on python38
  doCheck = !(stdenv.isDarwin && pythonAtLeast "3.8");
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Reader for the MaxMind DB format";
    homepage = "https://github.com/maxmind/MaxMind-DB-Reader-python";
<<<<<<< HEAD
    changelog = "https://github.com/maxmind/MaxMind-DB-Reader-python/blob/v${version}/HISTORY.rst";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
