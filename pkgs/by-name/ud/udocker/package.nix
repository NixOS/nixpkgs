{
  lib,
  fetchFromGitHub,
  singularity,
  python3Packages,
  testers,
  udocker,
}:

python3Packages.buildPythonApplication rec {
  pname = "udocker";
  version = "1.3.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "indigo-dc";
    repo = "udocker";
    tag = version;
    hash = "sha256-P49fkLvdCm/Eco+nD3SGM04PRQatBzq9CHlayueQetk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner'," ""
  '';

  # crun patchelf proot runc fakechroot
  # are download statistically linked during runtime
  buildInputs = [
    singularity
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    pycurl
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  disabledTests = [
    "test_02__load_structure"
    "test_05__get_volume_bindings"
  ];

  disabledTestPaths = [
    # Network
    "tests/unit/test_curl.py"
    "tests/unit/test_dockerioapi.py"
  ];

  pythonImportsCheck = [ "udocker" ];

  passthru = {
    tests.version = testers.testVersion { package = udocker; };
  };

  meta = {
    description = "Basic user tool to execute simple docker containers in user space without root privileges";
    homepage = "https://indigo-dc.gitbooks.io/udocker";
    changelog = "https://github.com/indigo-dc/udocker/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bzizou ];
    platforms = lib.platforms.linux;
    mainProgram = "udocker";
  };
}
