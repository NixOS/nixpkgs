{ stdenv, fetchPypi, buildPythonPackage, nose, mock, glibcLocales, isPy3k, isPy38 }:

buildPythonPackage rec {
  pname = "parameterized";
  version = "0.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "190f8cc7230eee0b56b30d7f074fd4d165f7c45e6077582d0813c8557e738490";
  };

  # Tests require some python3-isms but code works without.
  # python38 is not fully supported yet
  doCheck = isPy3k && (!isPy38);

  checkInputs = [ nose mock glibcLocales ];

  checkPhase = ''
    LC_ALL="en_US.UTF-8" nosetests -v
  '';

  meta = with stdenv.lib; {
    description = "Parameterized testing with any Python test framework";
    homepage = "https://pypi.python.org/pypi/parameterized";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ma27 ];
  };
}
