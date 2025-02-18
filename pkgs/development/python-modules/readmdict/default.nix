{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  poetry-core,
  python-lzo,
  tkinter,

  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "readmdict";
  version = "0.1.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ffreemt";
    repo = "readmdict";
    rev = "v${version}";
    hash = "sha256-1/f+o2bVscT3EA8XQyS2hWjhimLRzfIBM6u2O7UqwcA=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    python-lzo
    tkinter
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "readmdict" ];

  meta = with lib; {
    description = "Read mdx/mdd files (repacking of readmdict from mdict-analysis)";
    mainProgram = "readmdict";
    homepage = "https://github.com/ffreemt/readmdict";
    license = licenses.mit;
    maintainers = [ ];
  };
}
