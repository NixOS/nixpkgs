{ lib, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "emoji";
  name = "${pname}-${version}";
  version = "0.4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13i9mgkpll8m92b8mgm5yab4i78nwsl9h38nriavg105id94mg6q";
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
