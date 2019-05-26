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
  version = "2019.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f6972030e6c97089e49b832fd1f4e7959aee89bb6db929aaa3bde2553d78872b";
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