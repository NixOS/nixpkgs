{ lib, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "emoji";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e42da4f8d648f8ef10691bc246f682a1ec6b18373abfd9be10ec0b398823bd11";
  };

  checkInputs = [ nose ];

  checkPhase = "nosetests";

  meta = with lib; {
    description = "Emoji for Python";
    homepage = "https://pypi.python.org/pypi/emoji/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ joachifm ];
  };
}
