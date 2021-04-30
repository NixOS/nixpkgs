{ lib
, fetchFromGitHub
, buildPythonPackage
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jpylyzer";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "openpreserve";
    repo = pname;
    rev = version;
    sha256 = "01wfbb1bgby9b7m6q7483kvpyc1qhj80dg8d5a6smcxvmy8y6x5n";
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
