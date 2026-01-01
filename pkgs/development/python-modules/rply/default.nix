{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  appdirs,
  py,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rply";
  version = "0.7.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "alex";
    repo = "rply";
    rev = "v${version}";
    hash = "sha256-mO/wcIsDIBjoxUsFvzftj5H5ziJijJcoyrUk52fcyE4=";
  };

  propagatedBuildInputs = [ appdirs ];

  nativeCheckInputs = [
    py
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

<<<<<<< HEAD
  meta = {
    description = "Python Lex/Yacc that works with RPython";
    homepage = "https://github.com/alex/rply";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nixy ];
=======
  meta = with lib; {
    description = "Python Lex/Yacc that works with RPython";
    homepage = "https://github.com/alex/rply";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nixy ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
