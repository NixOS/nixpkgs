{ stdenv, fetchPypi, buildPythonPackage, nose, mock, glibcLocales, isPy3k, isPy38 }:

buildPythonPackage rec {
  pname = "parameterized";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6a94dbea30c6abde99fd4c2f2042c1bf7f980e48908bf92ead62394f93cf57ed";
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
    homepage = https://pypi.python.org/pypi/parameterized;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ma27 ];
  };
}
