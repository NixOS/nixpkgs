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
  version = "2018.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3b3f41e1235b579dc4f4a3d6f5f8ae187841968e72a4f73ac481c6bfe4c1668b";
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