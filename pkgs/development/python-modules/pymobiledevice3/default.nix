{
  bpylist2,
  buildPythonPackage,
  click,
  coloredlogs,
  construct,
<<<<<<< HEAD
  construct-typing,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
  pytun-pmd3,
  pyusb,
  qh3,
  requests,
  setuptools,
  setuptools-scm,
  srptools,
  sslpsk-pmd3,
  tqdm,
  uvicorn,
  wsproto,
  xonsh,
}:

buildPythonPackage rec {
  pname = "pymobiledevice3";
<<<<<<< HEAD
  version = "6.2.0";
=======
  version = "6.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "doronz88";
    repo = "pymobiledevice3";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Sc02p2zZb/CPYFU+lz6fe1UZgWhdJYH2/pSJ5gVE0iY=";
=======
    hash = "sha256-l6QS8xwcnjrBzbkQkkCyn+teD5J6AKAQuLoVsIzLlSE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    bpylist2
    click
    coloredlogs
    construct
<<<<<<< HEAD
    construct-typing
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
    sslpsk-pmd3
    tqdm
    uvicorn
    wsproto
    xonsh
  ]
  ++ fastapi.optional-dependencies.all;

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
