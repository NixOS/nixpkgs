{ stdenv, buildPythonPackage, fetchPypi
, mock, pytest
, six
}:
buildPythonPackage rec {
  pname = "PyHamcrest";
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ffaa0a53da57e89de14ced7185ac746227a8894dbd5a3c718bf05ddbd1d56cd";
  };

  checkInputs = [ mock pytest ];
  propagatedBuildInputs = [ six ];

  doCheck = false;  # pypi tarball does not include tests

  meta = with stdenv.lib; {
    homepage = https://github.com/hamcrest/PyHamcrest;
    description = "Hamcrest framework for matcher objects";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      alunduil
    ];
  };
}
