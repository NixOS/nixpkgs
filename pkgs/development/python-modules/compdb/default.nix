{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "compdb";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Sarcasm";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ssq26hp7590zpygxmbyx5z0mqbcajbk94rwlipymj9qsam9s8wy";
  };

  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "compdb" ];

  meta = with lib; {
    description = "The compilation database Swiss army knife";
    license = licenses.mit;
    homepage = "https://github.com/Sarcasm/compdb";
    maintainers = with maintainers; [ kcalvinalvin ];
  };
}
