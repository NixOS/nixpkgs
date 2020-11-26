{ lib
, buildPythonPackage
, fetchPypi
, pytest
, six
}:

buildPythonPackage rec {
  pname = "docrep";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef6e7433716c0d2c59889aae8bff800b48e82d7e759dfd934b93100dc7bccaa1";
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
