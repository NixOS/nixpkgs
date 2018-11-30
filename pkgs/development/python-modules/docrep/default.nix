{ lib
, buildPythonPackage
, fetchPypi
, pytest
, six
}:

buildPythonPackage rec {
  pname = "docrep";
  version = "0.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d195b6dfcf4efe5cb65402b6c6f6d7e6db77ce255887fae32c9a8288a022659";
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
    homepage = https://github.com/Chilipp/docrep;
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
