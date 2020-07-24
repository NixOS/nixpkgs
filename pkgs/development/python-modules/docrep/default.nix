{ lib
, buildPythonPackage
, fetchPypi
, pytest
, six
}:

buildPythonPackage rec {
  pname = "docrep";
  version = "0.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c48939ae14d79172839a5bbaf5a570add47f6cc44d2c18f6b1fac8f1c38dec4d";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ six ];

  checkPhase = ''
    py.test
  '';

  # tests not packaged with PyPi download
  doCheck = false;

  meta = {
    description = "Python package for docstring repetition";
    homepage = "https://github.com/Chilipp/docrep";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
