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
  version = "1.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7a5b83cd0f4d095e59d80c648ebb5f7ffca0cd8bcf7ae6639828ee1ad000632a";
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
