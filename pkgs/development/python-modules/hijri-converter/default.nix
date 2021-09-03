{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "hijri-converter";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-25pfMciEJUFjr2ocOb6ByAel6Je6lYdiTWcG3RBI8WA=";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Accurate Hijri-Gregorian date converter based on the Umm al-Qura calendar";
    homepage = "https://github.com/dralshehri/hijri-converter";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
