{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, blessed
, prefixed
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "enlighten";
  version = "1.10.1";

  src = fetchFromGitHub {
     owner = "Rockhopper-Technologies";
     repo = "enlighten";
     rev = "1.10.1";
     sha256 = "1dsscsp9q67ky91b43zabqlq67wavizbbcxfw6xq2451xls53sap";
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
