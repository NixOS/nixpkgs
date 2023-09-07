{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
, pythonRelaxDepsHook
, setuptools-scm
, appdirs
, colorama
, configobj
, distro
, dpath
, dvc-azure
, dvc-data
, dvc-gs
, dvc-http
, dvc-render
, dvc-s3
, dvc-ssh
, dvc-studio-client
, dvc-task
, flatten-dict
, flufl_lock
, funcy
, grandalf
, hydra-core
, importlib-metadata
, importlib-resources
, iterative-telemetry
, networkx
, packaging
, pathspec
, platformdirs
, psutil
, pydot
, pygtrie
, pyparsing
, requests
, rich
, ruamel-yaml
, scmrepo
, shortuuid
, shtab
, tabulate
, tomlkit
, tqdm
, typing-extensions
, voluptuous
, zc_lockfile
, enableGoogle ? false
, enableAWS ? false
, enableAzure ? false
, enableSSH ? false
}:

buildPythonPackage rec {
  pname = "dvc";
  version = "3.18.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-wTKQmFvI4kaXGivRiGDoI4lM/xHxYUDBqplscvjVQRs=";
  };

  pythonRelaxDeps = [
    "dvc-data"
    "platformdirs"
  ];

  postPatch = ''
    substituteInPlace dvc/analytics.py --replace 'enabled = not os.getenv(DVC_NO_ANALYTICS)' 'enabled = False'
    substituteInPlace dvc/daemon.py \
      --subst-var-by dvc "$out/bin/dcv"
  '';

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools-scm
  ];

  propagatedBuildInputs = [
    appdirs
    colorama
    configobj
    distro
    dpath
    dvc-data
    dvc-http
    dvc-render
    dvc-studio-client
    dvc-task
    flatten-dict
    flufl_lock
    funcy
    grandalf
    hydra-core
    iterative-telemetry
    networkx
    packaging
    pathspec
    platformdirs
    psutil
    pydot
    pygtrie
    pyparsing
    requests
    rich
    ruamel-yaml
    scmrepo
    shortuuid
    shtab
    tabulate
    tomlkit
    tqdm
    typing-extensions
    voluptuous
    zc_lockfile
  ]
  ++ lib.optionals enableGoogle passthru.optional-dependencies.gs
  ++ lib.optionals enableAWS passthru.optional-dependencies.s3
  ++ lib.optionals enableAzure passthru.optional-dependencies.azure
  ++ lib.optionals enableSSH passthru.optional-dependencies.ssh
  ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  passthru.optional-dependencies = {
    azure = [ dvc-azure ];
    gs = [ dvc-gs ];
    s3 = [ dvc-s3 ];
    ssh = [ dvc-ssh ];
  };

  # Tests require access to real cloud services
  doCheck = false;

  pythonImportsCheck = [ "dvc" "dvc.api" ];

  meta = with lib; {
    description = "Version Control System for Machine Learning Projects";
    homepage = "https://dvc.org";
    changelog = "https://github.com/iterative/dvc/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ cmcdragonkai fab ];
  };
}
