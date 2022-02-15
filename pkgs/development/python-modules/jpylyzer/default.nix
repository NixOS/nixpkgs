{ lib
, fetchFromGitHub
, buildPythonPackage
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jpylyzer";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "openpreserve";
    repo = pname;
    rev = version;
    sha256 = "1cd9klq83g9p4nkg7x78axqid5vcsqzggp431hcfdiixa50yjxjg";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "jpylyzer" ];

  meta = with lib; {
    description = "JP2 (JPEG 2000 Part 1) image validator and properties extractor";
    homepage = "https://jpylyzer.openpreservation.org/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ ris ];
  };
}
