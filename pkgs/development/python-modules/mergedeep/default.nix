{ lib, stdenv, buildPythonPackage, isPy27, fetchFromGitHub, pytest }:

buildPythonPackage rec {
  pname = "mergedeep";
  version = "1.3.1";
  disabled = isPy27;

  # PyPI tarball doesn't include tests directory
  src = fetchFromGitHub {
    owner = "clarketm";
    repo = "mergedeep";
    rev = "v${version}";
    sha256 = "1ryccb64hg438y1wsjlfp4ciq05q4c6khwhllwdnndm8cbkbrgph";
  };

  checkInputs = [ pytest ];
  checkPhase = "pytest";
  pythonImportsCheck = [ "mergedeep" ];

  meta = with lib; {
    homepage = "https://github.com/clarketm/mergedeep";
    description = "A deep merge function for python";
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };
}
