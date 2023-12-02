{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "filecheck";
  version = "0.0.24";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mull-project";
    repo = "FileCheck.py";
    rev = "refs/tags/v${version}";
    hash = "sha256-VbMlCqGd3MVpj0jEKjSGC2L0s/3e/d53b+2eZcXZneo=";
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
