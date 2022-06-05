{ lib, buildPythonApplication, fetchFromGitHub, pytestCheckHook, pytest-dependency, aspell-python, aspellDicts, chardet }:

buildPythonApplication rec {
  pname = "codespell";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "codespell-project";
    repo = "codespell";
    rev = "v${version}";
    sha256 = "sha256-BhYVztSr2MalILEcOcvMl07CObYa73o3kW8S/idqAO8=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=codespell_lib" "" \
      --replace "--cov-report=" ""
  '';

  checkInputs = [ aspell-python chardet pytestCheckHook pytest-dependency ];

  preCheck = ''
    export ASPELL_CONF="dict-dir ${aspellDicts.en}/lib/aspell"
  '';

  # tries to run not fully installed script
  disabledTests = [ "test_command" ];

  pythonImportsCheck = [ "codespell_lib" ];

  meta = with lib; {
    description = "Fix common misspellings in source code";
    homepage = "https://github.com/codespell-project/codespell";
    license = with licenses; [ gpl2Only cc-by-sa-30 ];
    maintainers = with maintainers; [ johnazoidberg SuperSandro2000 ];
  };
}
