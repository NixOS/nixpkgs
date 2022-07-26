{ lib, buildPythonPackage, fetchPypi
, mock, pytest
, six
}:
buildPythonPackage rec {
  pname = "PyHamcrest";
  version = "2.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dfb19cf6d71743e086fbb761ed7faea5aacbc8ec10c17a08b93ecde39192a3db";
  };

  checkInputs = [ mock pytest ];
  propagatedBuildInputs = [ six ];

  doCheck = false;  # pypi tarball does not include tests

  meta = with lib; {
    homepage = "https://github.com/hamcrest/PyHamcrest";
    description = "Hamcrest framework for matcher objects";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      alunduil
    ];
  };
}
