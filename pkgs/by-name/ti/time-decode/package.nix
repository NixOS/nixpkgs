{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "time-decode";
  version = "7.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "digitalsleuth";
    repo = "time_decode";
    rev = "refs/tags/v${version}";
    hash = "sha256-K60xIQ6TWPYlsR6YjIquey5Ioaw4oAId59CPlQNK4yk=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    colorama
    python-dateutil
    pyqt6
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "time_decode"
  ];

  meta = with lib; {
    description = "Timestamp and date decoder";
    homepage = "https://github.com/digitalsleuth/time_decode";
    changelog = "https://github.com/digitalsleuth/time_decode/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "time-decode";
  };
}
