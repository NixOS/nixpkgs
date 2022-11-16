{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, repeated-test
}:

buildPythonPackage rec {
  pname = "od";
  version = "2.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uGkj2Z8mLg51IV+FOqwZl1hT7zVyjmD1CcY/VbH4tKk=";
  };

  checkInputs = [
    repeated-test
  ];

  meta = with lib; {
    description = "Shorthand syntax for building OrderedDicts";
    homepage = "https://github.com/epsy/od";
    license = licenses.mit;
  };
}
