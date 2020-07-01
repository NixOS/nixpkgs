{ stdenv, buildPythonPackage, fetchPypi, flake8, six, orderedmultidict, pytest }:

buildPythonPackage rec {
  pname = "furl";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08dnw3bs1mk0f1ccn466a5a7fi1ivwrp0jspav9arqpf3wd27q60";
  };

  checkInputs = [ flake8 pytest ];

  propagatedBuildInputs = [ six orderedmultidict ];

  # see https://github.com/gruns/furl/issues/121
  checkPhase = ''
    pytest -k 'not join'
  '';

  meta = with stdenv.lib; {
    description = "furl is a small Python library that makes parsing and manipulating URLs easy";
    homepage = "https://github.com/gruns/furl";
    license = licenses.unlicense;
    maintainers = with maintainers; [ vanzef ];
  };
}
