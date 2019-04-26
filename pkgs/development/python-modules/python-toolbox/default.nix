{ lib
, buildPythonPackage
, docutils
, fetchFromGitHub
, isPy27
, nose
}:

buildPythonPackage rec {
  version = "0.9.4";
  pname = "python_toolbox";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "cool-RR";
    repo = pname;
    rev = version;
    sha256 = "1qy2sfqfrkgxixmd22v5lkrdykdfiymsd2s3xa7ndlvg084cgj6r";
  };

  checkInputs = [
    docutils
    nose
  ];

  meta = with lib; {
    description = "Tools for testing PySnooper";
    homepage = https://github.com/cool-RR/python_toolbox;
    license = licenses.mit;
    maintainers = with maintainers; [ seqizz ];
  };
}
