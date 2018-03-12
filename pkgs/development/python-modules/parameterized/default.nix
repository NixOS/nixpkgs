{ stdenv, fetchPypi, buildPythonPackage, nose, six, glibcLocales, isPy3k }:

buildPythonPackage rec {
  pname = "parameterized";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qj1939shm48d9ql6fm1nrdy4p7sdyj8clz1szh5swwpf1qqxxfa";
  };

  # Tests require some python3-isms but code works without.
  doCheck = isPy3k;

  checkInputs = [ nose glibcLocales ];
  propagatedBuildInputs = [ six ];

  checkPhase = ''
    LC_ALL="en_US.UTF-8" nosetests -v
  '';

  meta = with stdenv.lib; {
    description = "Parameterized testing with any Python test framework";
    homepage = https://pypi.python.org/pypi/parameterized;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ma27 ];
  };
}
