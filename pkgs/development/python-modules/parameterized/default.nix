{ lib, fetchPypi, buildPythonPackage, nose, mock, glibcLocales, isPy3k, isPy38 }:

buildPythonPackage rec {
  pname = "parameterized";
  version = "0.7.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b5e6af67b9e49485e30125b1c8f031ffa81a265ca08bfa73f31551bf03cf68c4";
  };

  # Tests require some python3-isms but code works without.
  # python38 is not fully supported yet
  doCheck = isPy3k && (!isPy38);

  checkInputs = [ nose mock glibcLocales ];

  checkPhase = ''
    LC_ALL="en_US.UTF-8" nosetests -v
  '';

  meta = with lib; {
    description = "Parameterized testing with any Python test framework";
    homepage = "https://pypi.python.org/pypi/parameterized";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ma27 ];
  };
}
