{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  blessed,
  prefixed,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "enlighten";
  version = "1.13.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7nGNqsaHPIP9Nwa8532kcsd2pR4Nb1+G9+YeJ/mtFmo=";
  };

  propagatedBuildInputs = [
    blessed
    prefixed
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "enlighten" ];

  disabledTests =
    [
      # AssertionError: <_io.TextIOWrapper name='<stdout>' mode='w' encoding='utf-8'> is not...
      "test_init"
      # AssertionError: Invalid format specifier (deprecated since prefixed 0.4.0)
      "test_floats_prefixed"
      "test_subcounter_prefixed"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
