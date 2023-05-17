{ lib
, buildPythonPackage
, fetchPypi
, pytest
, six
}:

buildPythonPackage rec {
  pname = "docrep";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ed8a17e201abd829ef8da78a0b6f4d51fb99a4cbd0554adbed3309297f964314";
  };

  nativeCheckInputs = [ pytest ];
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
