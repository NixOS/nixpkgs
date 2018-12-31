{ lib, buildPythonPackage, fetchPypi, unittest2, repeated_test }:

buildPythonPackage rec {
  pname = "od";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1az30snc3w6s4k1pi7mspcv8y0kp3ihf3ly44z517nszmz9lrjfi";
  };

  checkInputs = [
    repeated_test
    unittest2
  ];

  meta = with lib; {
    description = "Shorthand syntax for building OrderedDicts";
    homepage = https://github.com/epsy/od;
    license = licenses.mit;
  };

}
