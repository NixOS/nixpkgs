{ lib, fetchPypi, buildPythonPackage, nose, mock, glibcLocales, isPy3k, isPy38 }:

buildPythonPackage rec {
  pname = "parameterized";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "41bbff37d6186430f77f900d777e5bb6a24928a1c46fb1de692f8b52b8833b5c";
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
