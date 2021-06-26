{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "hijri-converter";
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "43b5ac566e7a7deeab364a2397e94405a65fd24ea786073eb3d4c740ebda7b9b";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Accurate Hijri-Gregorian date converter based on the Umm al-Qura calendar";
    homepage = "https://github.com/dralshehri/hijri-converter";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
