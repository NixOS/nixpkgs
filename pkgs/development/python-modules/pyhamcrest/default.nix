{ lib, buildPythonPackage, fetchPypi
, mock, pytest
, six
}:
buildPythonPackage rec {
  pname = "PyHamcrest";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "412e00137858f04bde0729913874a48485665f2d36fe9ee449f26be864af9316";
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
