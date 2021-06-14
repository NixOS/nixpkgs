{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "hijri-converter";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08gv6ypn2zd0i8yrv24m448xkic492qrgxj349slp1achhg9p7ln";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Accurate Hijri-Gregorian date converter based on the Umm al-Qura calendar";
    homepage = "https://github.com/dralshehri/hijri-converter";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
