{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, isPyPy
, pythonAtLeast
, pythonOlder
, tzdata
=======
, pythonAtLeast
, pythonOlder
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

# tests
, freezegun
, pytestCheckHook
, pytz
}:

buildPythonPackage rec {
  pname = "babel";
  version = "2.12.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Babel";
    inherit version;
    hash = "sha256-zC2ZmZzQHURCCuclohyeNxGzqtx5dtYUf2IthYGWNFU=";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.9") [
    pytz
  ];

  # including backports.zoneinfo for python<3.9 yields infinite recursion
  doCheck = pythonAtLeast "3.9";

  nativeCheckInputs = [
<<<<<<< HEAD
    freezegun
    pytestCheckHook
    # https://github.com/python-babel/babel/issues/988#issuecomment-1521765563
    pytz
  ] ++ lib.optionals isPyPy [
    tzdata
=======
    # via setup.py
    freezegun
    pytestCheckHook
    # via tox.ini
    pytz
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  disabledTests = [
    # fails on days switching from and to daylight saving time in EST
    # https://github.com/python-babel/babel/issues/988
    "test_format_time"
  ];

  meta = with lib; {
    homepage = "https://babel.pocoo.org/";
    changelog = "https://github.com/python-babel/babel/releases/tag/v${version}";
    description = "Collection of internationalizing tools";
    license = licenses.bsd3;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
