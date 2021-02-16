{ lib, buildPythonApplication, fetchFromGitHub, pytestCheckHook, pytest-cov, pytest-dependency, aspell-python, aspellDicts, chardet }:

buildPythonApplication rec {
  pname = "codespell";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "codespell-project";
    repo = "codespell";
    rev = "v${version}";
    sha256 = "187g26s3wzjmvdx9vjabbnajpbg0s9klixyv6baymmgz9lrcv4ln";
  };

  checkInputs = [ aspell-python chardet pytestCheckHook pytest-cov pytest-dependency ];

  preCheck = ''
    export ASPELL_CONF="dict-dir ${aspellDicts.en}/lib/aspell"
  '';

  # tries to run not rully installed script
  disabledTests = [ "test_command" ];

  pythonImportsCheck = [ "codespell_lib" ];

  meta = with lib; {
    description = "Fix common misspellings in source code";
    homepage = "https://github.com/codespell-project/codespell";
    license = with licenses; [ gpl2Only cc-by-sa-30 ];
    maintainers = with maintainers; [ johnazoidberg SuperSandro2000 ];
  };
}
