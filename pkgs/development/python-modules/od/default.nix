{ lib, buildPythonPackage, fetchPypi, unittest2 }:

buildPythonPackage rec {
  pname = "od";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "180fb0d13c3af1384047b8296c95683816b5d0c68a60c22d07c703be8bd755cb";
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
