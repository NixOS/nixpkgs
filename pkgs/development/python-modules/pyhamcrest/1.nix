{ stdenv, buildPythonPackage, fetchPypi
, mock, pytest
, six
}:
buildPythonPackage rec {
  pname = "PyHamcrest";
  version = "1.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0x08lfcnsak7pkym32xrdn0sn3wcf26n1jff3d11mwbizpfikbpp";
  };

  checkInputs = [ mock pytest ];
  propagatedBuildInputs = [ six ];

  doCheck = false;  # pypi tarball does not include tests

  meta = with stdenv.lib; {
    homepage = "https://github.com/hamcrest/PyHamcrest";
    description = "Hamcrest framework for matcher objects";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      alunduil
    ];
  };
}
