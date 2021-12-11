{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "hijri-converter";
  version = "2.2.2";

  src = fetchFromGitHub {
     owner = "dralshehri";
     repo = "hijri-converter";
     rev = "v2.2.2";
     sha256 = "19hvqs8cp07y5xjrd9kkw2sbykl2xpb1986r9gwgnwhnl7hacyr0";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hijri_converter" ];

  meta = with lib; {
    description = "Accurate Hijri-Gregorian date converter based on the Umm al-Qura calendar";
    homepage = "https://github.com/dralshehri/hijri-converter";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
