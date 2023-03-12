{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# tests
, backports-zoneinfo
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

  nativeCheckInputs = [
    # via setup.py
    freezegun
    pytestCheckHook
    # via tox.ini
    pytz
  ] ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
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
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
