{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, hypothesis, mypy }:

buildPythonPackage rec {
  pname = "algebraic-data-types";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "jspahrsummers";
    repo = "adt";
    rev = "v" + version;
    sha256 = "1py94jsgh6wch59n9dxnwvk74psbpa1679zfmripa1qfc2218kqi";
  };

  disabled = pythonOlder "3.6";

  checkInputs = [
    hypothesis
    mypy
  ];

  meta = with lib; {
    description = "Algebraic data types for Python";
    homepage = "https://github.com/jspahrsummers/adt";
    license = licenses.mit;
    maintainers = with maintainers; [ uri-canva ];
    platforms = platforms.unix;
  };
}
