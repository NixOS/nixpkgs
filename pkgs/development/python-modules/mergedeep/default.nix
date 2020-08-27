{ stdenv, buildPythonPackage, isPy27, fetchFromGitHub, pytest }:

buildPythonPackage rec {
  pname = "mergedeep";
  version = "1.3.0";
  disabled = isPy27;

  # PyPI tarball doesn't include tests directory
  src = fetchFromGitHub {
    owner = "clarketm";
    repo = "mergedeep";
    rev = "v${version}";
    sha256 = "1a0y26a04limiggjwqyyqpryxiylbqya74nq1bij75zhz42sa02b";
  };

  checkInputs = [ pytest ];
  checkPhase = "pytest";
  pythonImportsCheck = [ "mergedeep" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/clarketm/mergedeep";
    description = "A deep merge function for python";
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };
}
