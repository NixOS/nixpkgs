{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "braviarc-homeassistant";
  version = "0.3.7.dev0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ylv76xc7a538m5520y32daglcysnpxxbvff2kh179jzp78k27qb";
  };

  propagatedBuildInputs = [ requests ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://pypi.org/project/braviarc-homeassistant";
    description = "(braviarc pkged for pypi?)";
    license = licenses.mit;
    maintainers = with maintainers; [ colemickens ];
  };
}
