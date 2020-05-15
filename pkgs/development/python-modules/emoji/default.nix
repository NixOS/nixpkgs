{ lib, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "emoji";
  version = "0.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0x61xypwswhghchp5svs084didkgfwqpq2fbiapvirff5lx2srb0";
  };

  checkInputs = [ nose ];

  checkPhase = ''nosetests'';

  meta = with lib; {
    description = "Emoji for Python";
    homepage = "https://pypi.python.org/pypi/emoji/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ joachifm ];
  };
}
