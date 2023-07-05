{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "looseversion";
  version = "1.2.0";
  format = "flit";

  src = fetchPypi {
    inherit version pname;
    sha256 = "sha256-xk5xwLKQMGg7Tqda7kMdstJcTm5TNZDlISnx2eUd4gQ=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];
  pytestFlagsArray = [ "tests.py" ];
  pythonImportsCheck = [ "looseversion" ];

  meta = with lib; {
    description = "Version numbering for anarchists and software realists";
    homepage = "https://github.com/effigies/looseversion";
    license = licenses.psfl;
    maintainers = with maintainers; [ pelme ];
  };
}
