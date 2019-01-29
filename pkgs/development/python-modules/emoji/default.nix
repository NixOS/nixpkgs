{ lib, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "emoji";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a9e9c08be9907c0042212c86dfbea0f61f78e9897d4df41a1d6307017763ad3e";
  };

  checkInputs = [ nose ];

  checkPhase = ''nosetests'';

  meta = with lib; {
    description = "Emoji for Python";
    homepage = https://pypi.python.org/pypi/emoji/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ joachifm ];
  };
}
