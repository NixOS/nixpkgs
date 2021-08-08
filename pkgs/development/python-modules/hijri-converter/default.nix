{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "hijri-converter";
  version = "2.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cq67v0fjk7cd8kbppg2kl31a5i6jm8qrkcdqxx6vxwmx65l68ks";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Accurate Hijri-Gregorian date converter based on the Umm al-Qura calendar";
    homepage = "https://github.com/dralshehri/hijri-converter";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
