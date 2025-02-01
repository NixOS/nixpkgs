{
  lib,
  python3,
  fetchFromGitHub,
  deterministic-uname,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "zxpy";
  version = "1.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tusharsadhwani";
    repo = "zxpy";
    tag = version;
    hash = "sha256-/VITHN517lPUmhLYgJHBYYvvlJdGg2Hhnwk47Mp9uc0=";
  };

  build-system = [
    python3.pkgs.setuptools
  ];

  nativeCheckInputs = [
    deterministic-uname
    python3.pkgs.pytestCheckHook
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  pythonImportsCheck = [ "zx" ];

  meta = {
    description = "Shell scripts made simple";
    homepage = "https://github.com/tusharsadhwani/zxpy";
    changelog = "https://github.com/tusharsadhwani/zxpy/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "zxpy";
  };
}
