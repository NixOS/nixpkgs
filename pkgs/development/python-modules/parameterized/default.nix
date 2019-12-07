{ stdenv, fetchPypi, buildPythonPackage, nose, mock, glibcLocales, isPy3k, isPy38 }:

buildPythonPackage rec {
  pname = "parameterized";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d8c8837fb677ed2d5a93b9e2308ce0da3aeb58cf513120d501e0b7af14da78d5";
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
