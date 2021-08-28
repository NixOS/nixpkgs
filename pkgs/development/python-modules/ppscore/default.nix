{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, pandas
, scikit-learn
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ppscore";
  version = "1.1.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "8080labs";
    repo = pname;
    rev = version;
    sha256 = "11y6axhj0nlagf7ax6gas1g06krrmddb1jlmf0mmrmyi7z0vldk2";
  };

  checkInputs = [ pytestCheckHook ];

  propagatedBuildInputs = [
    pandas
    scikit-learn
  ];

  meta = with lib; {
    description = "A Python implementation of the Predictive Power Score (PPS)";
    homepage = "https://github.com/8080labs/ppscore/";
    license = licenses.mit;
    maintainers = with maintainers; [ evax ];
  };
}
