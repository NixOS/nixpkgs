{ lib
, buildPythonPackage
, fetchPypi
, decorator
, appdirs
, six
, numpy
, pytest
}:

buildPythonPackage rec {
  pname = "pytools";
  version = "2018.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f9746ef763ce4d7d59ee8506ee83dd684884e4b520244b67f253095decc8a876";
  };

  checkInputs = [ pytest ];

  propagatedBuildInputs = [
    decorator
    appdirs
    six
    numpy
  ];

  checkPhase = ''
    py.test -k 'not test_persistent_dict'
  '';

  meta = {
    homepage = https://github.com/inducer/pytools/;
    description = "Miscellaneous Python lifesavers.";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ artuuge ];
  };
}