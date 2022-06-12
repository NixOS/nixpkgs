{ lib, buildPythonPackage, fetchPypi, unittest2 }:

buildPythonPackage rec {
  pname = "od";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uGkj2Z8mLg51IV+FOqwZl1hT7zVyjmD1CcY/VbH4tKk=";
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
