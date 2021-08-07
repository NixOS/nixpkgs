{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, decorator
, appdirs
, six
, numpy
, pytest
}:

buildPythonPackage rec {
  pname = "pytools";
  version = "2021.2.7";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0538f6fe7f00bf765ca5ab38518db48df72de818460006e54b0575accd24d9fb";
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
    homepage = "https://github.com/inducer/pytools/";
    description = "Miscellaneous Python lifesavers.";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ artuuge ];
  };
}
