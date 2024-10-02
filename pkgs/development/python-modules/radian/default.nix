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
  git,
  lineedit,
  prompt-toolkit,
  pygments,
  rchitect,
  R,
  rPackages,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "radian";
  version = "0.6.13";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "randy3k";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-gz2VczAgVbvISzvY/v0GvZ/Erv6ipZwPU61r6OJ+3Fo=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [
    R # needed at setup time to detect R_HOME
  ];

  propagatedBuildInputs =
    [
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
    git
  ];

  makeWrapperArgs = [ "--set R_HOME ${R}/lib/R" ];

  preCheck = ''
    export HOME=$TMPDIR
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${R}/lib/R/lib
  '';

  pythonImportsCheck = [ "radian" ];

  meta = with lib; {
    description = "21 century R console";
    mainProgram = "radian";
    homepage = "https://github.com/randy3k/radian";
    changelog = "https://github.com/randy3k/radian/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ savyajha ];
  };
}
