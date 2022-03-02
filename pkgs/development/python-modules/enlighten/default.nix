{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, blessed
, prefixed
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "enlighten";
  version = "1.10.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eluDzQ9NCV5Z2Axkjrtff/ygzYvPeuZjmCjuGtAAYyo=";
  };

  propagatedBuildInputs = [
    blessed
    prefixed
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "enlighten"
  ];

  disabledTests = [
    # AssertionError: <_io.TextIOWrapper name='<stdout>' mode='w' encoding='utf-8'> is not...
    "test_init"
  ] ++ lib.optional stdenv.isDarwin [
    # https://github.com/Rockhopper-Technologies/enlighten/issues/44
    "test_autorefresh"
  ];

  meta = with lib; {
    description = "Enlighten Progress Bar for Python Console Apps";
    homepage = "https://github.com/Rockhopper-Technologies/enlighten";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
