{ lib
, buildPythonApplication
, fetchFromGitHub
, poetry
}:

buildPythonApplication rec {
  pname = "filecheck";
  version = "0.0.22";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mull-project";
    repo = "FileCheck.py";
    rev = "v${version}";
    sha256 = "sha256-I2SypKkgcVuLyLiwNw5oWDb9qT56TbC6vbui8PEcziI=";
  };

  nativeBuildInputs = [ poetry ];

  pythonImportsCheck = [ "filecheck" ];

  meta = with lib; {
    homepage = "https://github.com/mull-project/FileCheck.py";
    license = licenses.asl20;
    description = "Python port of LLVM's FileCheck, flexible pattern matching file verifier";
    maintainers = with maintainers; [ yorickvp ];
  };
}
