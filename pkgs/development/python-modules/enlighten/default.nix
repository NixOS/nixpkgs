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
  version = "1.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-a4r20HG13gUBOjjoDhaHJtxv+yhY3oF/d+QV+Fss6Bk=";
  };

  propagatedBuildInputs = [
    blessed
    prefixed
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "enlighten"
  ];

  disabledTests = [
    # AssertionError: <_io.TextIOWrapper name='<stdout>' mode='w' encoding='utf-8'> is not...
    "test_init"
    # AssertionError: Invalid format specifier (deprecated since prefixed 0.4.0)
    "test_floats_prefixed"
    "test_subcounter_prefixed"
  ] ++ lib.optionals stdenv.isDarwin [
    # https://github.com/Rockhopper-Technologies/enlighten/issues/44
    "test_autorefresh"
  ];

  meta = with lib; {
    description = "Enlighten Progress Bar for Python Console Apps";
    homepage = "https://github.com/Rockhopper-Technologies/enlighten";
    changelog = "https://github.com/Rockhopper-Technologies/enlighten/releases/tag/${version}";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
