{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pyte,
  pexpect,
  ptyprocess,
  pythonOlder,
  jedi,
  gitMinimal,
  lineedit,
  prompt-toolkit,
  pygments,
  rchitect,
  R,
  rPackages,
  writableTmpDirAsHomeHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "radian";
  version = "0.6.15";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "randy3k";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-9dpLQ3QRppvwOw4THASfF8kCkIVZmWLALLRwy1LRPiE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [
    R # needed at setup time to detect R_HOME
  ];

  propagatedBuildInputs = [
    lineedit
    prompt-toolkit
    pygments
    rchitect
  ]
  ++ (with rPackages; [
    reticulate
    askpass
  ]);

  nativeCheckInputs = [
    pytestCheckHook
    pyte
    pexpect
    ptyprocess
    jedi
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  makeWrapperArgs = [ "--set R_HOME ${R}/lib/R" ];

  preCheck = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${R}/lib/R/lib
  '';

  pythonImportsCheck = [ "radian" ];

  meta = {
    description = "21 century R console";
    mainProgram = "radian";
    homepage = "https://github.com/randy3k/radian";
    changelog = "https://github.com/randy3k/radian/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ savyajha ];
  };
}
