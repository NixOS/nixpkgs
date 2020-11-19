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
  version = "2020.4.3";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "21aa1fd942bc3bc54c8ae3b5e60c1f771e6db0817b7402fd802aa5964f20e629";
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
