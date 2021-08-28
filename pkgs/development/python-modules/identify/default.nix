{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, editdistance
}:

buildPythonPackage rec {
  pname = "identify";
  version = "1.6.1";


  src = fetchFromGitHub {
    owner = "pre-commit";
    repo = pname;
    rev = "v${version}";
    sha256 = "1sqhqqjp53dwm8yq4nrgggxbvzs3szbg49z5sj2ss9xzlgmimclm";
  };

  checkInputs = [
    editdistance
    pytestCheckHook
  ];

  pythonImportsCheck = [ "identify" ];

  meta = with lib; {
    description = "File identification library for Python";
    homepage = "https://github.com/chriskuehl/identify";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
