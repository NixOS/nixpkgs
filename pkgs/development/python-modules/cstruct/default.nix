{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cstruct";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "andreax79";
    repo = "python-cstruct";
    rev = "v${version}";
    sha256 = "5HO5P7Y7NAFTYxu1QOwZj5oaHMDGnF2Y/YzeZLFSw14=";
  };

  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "cstruct" ];

  meta = with lib; {
    description = "C-style structs for Python";
    homepage = "http://github.com/andreax79/python-cstruct";
    license = licenses.mit;
    maintainers = with maintainers; [ emilytrau ];
  };
}
