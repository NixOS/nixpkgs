{
  lib,
  python3Packages,
  fetchFromGitHub,
  deterministic-uname,
  addBinToPathHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "zxpy";
  version = "1.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tusharsadhwani";
    repo = "zxpy";
    tag = version;
    hash = "sha256-/VITHN517lPUmhLYgJHBYYvvlJdGg2Hhnwk47Mp9uc0=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  nativeCheckInputs =
    with python3Packages;
    [
      deterministic-uname
      pytestCheckHook
    ]
    ++ [
      addBinToPathHook
    ];

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
