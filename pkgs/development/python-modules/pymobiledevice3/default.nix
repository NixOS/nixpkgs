{
  bpylist2,
  buildPythonPackage,
  coloredlogs,
  construct,
  construct-typing,
  cryptography,
  daemonize,
  developer-disk-image,
  fastapi,
  fetchFromGitHub,
  gpxpy,
  hexdump,
  hyperframe,
  ifaddr,
  inquirer3,
  ipsw-parser,
  ipython,
  lib,
  nest-asyncio,
  opack2,
  packaging,
  parameter-decorators,
  pillow,
  plumbum,
  psutil,
  pycrashreport,
  pygments,
  pygnuutils,
  pykdebugparser,
  pytest-asyncio,
  pytestCheckHook,
  python-pcapng,
  pythonOlder,
  pytun-pmd3,
  pyusb,
  qh3,
  requests,
  setuptools,
  setuptools-scm,
  srptools,
  sslpsk-pmd3,
  tqdm,
  typer,
  typer-injector,
  uvicorn,
  wsproto,
  xonsh,
}:

buildPythonPackage rec {
  pname = "pymobiledevice3";
  version = "7.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "doronz88";
    repo = "pymobiledevice3";
    tag = "v${version}";
    hash = "sha256-j183S5H6jUnhOn/xMfeZtG9c4OowH/6HPpP2giko4dM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    bpylist2
    coloredlogs
    construct
    construct-typing
    cryptography
    daemonize
    developer-disk-image
    fastapi
    gpxpy
    hexdump
    hyperframe
    ifaddr
    inquirer3
    ipsw-parser
    ipython
    nest-asyncio
    opack2
    packaging
    parameter-decorators
    pillow
    plumbum
    psutil
    pycrashreport
    pygments
    pygnuutils
    pykdebugparser
    python-pcapng
    pytun-pmd3
    pyusb
    qh3
    requests
    srptools
    tqdm
    typer
    typer-injector
    uvicorn
    wsproto
    xonsh
  ]
  ++ lib.optionals (pythonOlder "3.13") [
    sslpsk-pmd3
  ];

  pythonImportsCheck = [ "pymobiledevice3" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  # Upstream only runs tests marked with 'cli' in CI:
  # https://github.com/doronz88/pymobiledevice3/blob/v4.27.1/.github/workflows/python-app.yml#L45
  enabledTestMarks = [ "cli" ];

  meta = {
    changelog = "https://github.com/doronz88/pymobiledevice3/releases/tag/${src.tag}";
    description = "Pure python3 implementation for working with iDevices (iPhone, etc.)";
    homepage = "https://github.com/doronz88/pymobiledevice3";
    license = lib.licenses.gpl3Plus;
    mainProgram = "pymobiledevice3";
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
