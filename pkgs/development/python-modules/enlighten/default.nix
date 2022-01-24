{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, blessed
, prefixed
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "enlighten";
  version = "1.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3391916586364aedced5d6926482b48745e4948f822de096d32258ba238ea984";
  };

  propagatedBuildInputs = [
    blessed
    prefixed
  ];
  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "enlighten" ];
  disabledTests =
    # https://github.com/Rockhopper-Technologies/enlighten/issues/44
    lib.optional stdenv.isDarwin "test_autorefresh"
    ;

  meta = with lib; {
    description = "Enlighten Progress Bar for Python Console Apps";
    homepage = "https://github.com/Rockhopper-Technologies/enlighten";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
