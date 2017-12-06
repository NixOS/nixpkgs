{ stdenv, buildPythonPackage, fetchPypi, pytest, six, doCheck ? true }:
buildPythonPackage rec {
  pname = "pluggy";
  version = "0.3.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18qfzfm40bgx672lkg8q9x5hdh76n7vax99aank7vh2nw21wg70m";
  };

  # Circular dependency on pytest
  #inherit doCheck;

  checkInputs = stdenv.lib.optionals doCheck [ pytest ];

  checkPhase = ''
    rm tox.ini
    pytest testing/
  '';

  meta = with stdenv.lib; {
    description = "Plugin and hook calling mechanisms for Python";
    homepage = "https://pypi.python.org/pypi/pluggy";
    license = licenses.mit;
    maintainers = with maintainers; [ jgeerds ];
  };
}
