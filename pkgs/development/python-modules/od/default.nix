{
  lib,
  buildPythonPackage,
  fetchPypi,
  repeated-test,
}:

buildPythonPackage rec {
  pname = "od";
  version = "2.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uGkj2Z8mLg51IV+FOqwZl1hT7zVyjmD1CcY/VbH4tKk=";
  };

  nativeCheckInputs = [ repeated-test ];

  pythonImportsCheck = [ "od" ];

  meta = {
    description = "Shorthand syntax for building OrderedDicts";
    homepage = "https://github.com/epsy/od";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
