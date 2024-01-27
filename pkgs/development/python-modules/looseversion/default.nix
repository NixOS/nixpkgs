{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, hatchling
}:

buildPythonPackage rec {
  pname = "looseversion";
  version = "1.3.0";
  format = "pyproject";

  src = fetchPypi {
    inherit version pname;
    sha256 = "sha256-695l8/a7lTGoEBbG/vPrlaYRga3Ee3+UnpwOpHkRZp4=";
  };

  nativeBuildInputs = [
    hatchling
  ];

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
