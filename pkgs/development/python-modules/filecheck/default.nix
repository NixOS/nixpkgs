{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "filecheck";
  version = "0.0.23";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mull-project";
    repo = "FileCheck.py";
    rev = "refs/tags/v${version}";
    hash = "sha256-R+e4Z1EX6Nk7INLar3gtkUpk+30xIJO7yiZbUvrhN74=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry>=0.12" "poetry-core" \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "filecheck"
  ];

  meta = with lib; {
    homepage = "https://github.com/mull-project/FileCheck.py";
    license = licenses.asl20;
    description = "Python port of LLVM's FileCheck, flexible pattern matching file verifier";
    maintainers = with maintainers; [ yorickvp ];
  };
}
