{ lib, buildPythonPackage, fetchPypi, unittest2 }:

buildPythonPackage rec {
  pname = "od";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1az30snc3w6s4k1pi7mspcv8y0kp3ihf3ly44z517nszmz9lrjfi";
  };

  # repeated_test no longer exists in nixpkgs
  # also see: https://github.com/epsy/od/issues/1
  doCheck = false;
  checkInputs = [
    unittest2
  ];

  meta = with lib; {
    description = "Shorthand syntax for building OrderedDicts";
    homepage = "https://github.com/epsy/od";
    license = licenses.mit;
  };

}
