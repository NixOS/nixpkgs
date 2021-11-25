{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "hijri-converter";
  version = "2.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1KENsAnBQXWSu/s96+yt+gTY2NXVG2Spcelp12Gp8+E=";
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
