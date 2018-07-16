{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "sarge";
  version = "0.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08s8896973bz1gg0pkr592w6g4p6v47bkfvws5i91p9xf8b35yar";
  };

  meta = with lib; {
    homepage = http://sarge.readthedocs.org/;
    description = "A wrapper for subprocess which provides command pipeline functionality";
    license = licenses.bsd3;
    maintainers = with maintainers; [ abbradar ];
  };
}
