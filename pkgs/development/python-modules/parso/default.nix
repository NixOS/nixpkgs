{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "parso";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2b6db14759c528d857eeb9eac559c2166b2554548af39f5198bdfb976f72aa64";
  };

  checkInputs = [ pytest ];

  meta = {
    description = "A Python Parser";
    homepage = "https://github.com/davidhalter/parso";
    license = lib.licenses.mit;
  };

}
