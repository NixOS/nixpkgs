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
    sha256 = "0q7i908ds1k79mi8g5dsjzlaa1y8h6z3j73amxil29c4r0qmz6nv";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Accurate Hijri-Gregorian date converter based on the Umm al-Qura calendar";
    homepage = "https://github.com/dralshehri/hijri-converter";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
