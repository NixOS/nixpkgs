{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "upiano";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eliasdorneles";
    repo = "upiano";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5WhflvUCjzW4ZJ+PLUTMbKcUnQa3ChkDjl0R5YvjBWk=";
    forceFetchGit = true;
    fetchLFS = true;
  };

  pythonRelaxDeps = [
    "textual"
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pyfluidsynth
    textual
  ];

  pythonImportsCheck = [
    "upiano"
  ];

  meta = {
    description = "Piano in your terminal";
    homepage = "https://github.com/eliasdorneles/upiano";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "upiano";
  };
})
