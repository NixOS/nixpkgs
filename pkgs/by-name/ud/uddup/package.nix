{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "uddup";
  version = "0.9.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rotemreiss";
    repo = "uddup";
    rev = "v${finalAttrs.version}";
    sha256 = "1f5dm3772hiik9irnyvbs7wygcafbwi7czw3b47cwhb90b8fi5hg";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    colorama
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "uddup"
  ];

  meta = {
    description = "Tool for de-duplication URLs";
    mainProgram = "uddup";
    homepage = "https://github.com/rotemreiss/uddup";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
