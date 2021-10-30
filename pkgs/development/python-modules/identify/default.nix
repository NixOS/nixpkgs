{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, editdistance-s
}:

buildPythonPackage rec {
  pname = "identify";
  version = "2.3.1";


  src = fetchFromGitHub {
    owner = "pre-commit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6sErta+YnaXe7lHR3kR7UAoWuaw8He7e3gCML9vWYj8=";
  };

  checkInputs = [
    editdistance-s
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
