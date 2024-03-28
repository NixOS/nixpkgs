{ lib
, appdirs
, buildPythonPackage
, colorama
, configobj
, distro
, dpath
, dvc-azure
, dvc-data
, dvc-gdrive
, dvc-gs
, dvc-hdfs
, dvc-http
, dvc-render
, dvc-s3
, dvc-ssh
, dvc-studio-client
, dvc-task
, fetchFromGitHub
, flatten-dict
, flufl-lock
, funcy
, grandalf
, gto
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
, pythonOlder
, pythonRelaxDepsHook
, requests
, rich
, ruamel-yaml
, scmrepo
, setuptools-scm
, shortuuid
, shtab
, tabulate
, tomlkit
, tqdm
, typing-extensions
, voluptuous
, zc-lockfile
, enableGoogle ? false
, enableAWS ? false
, enableAzure ? false
, enableSSH ? false
}:

buildPythonPackage rec {
  pname = "dvc";
  version = "3.49.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "dvc";
    rev = "refs/tags/${version}";
    hash = "sha256-Qu2+zTcTIPxLRZn1GB3Q6465kSEAuN+wessBVgxEdFU=";
  };

  pythonRelaxDeps = [
    "dvc-data"
    "platformdirs"
  ];

  postPatch = ''
    substituteInPlace dvc/analytics.py \
      --replace-fail 'enabled = not os.getenv(DVC_NO_ANALYTICS)' 'enabled = False'
    substituteInPlace dvc/daemon.py \
      --subst-var-by dvc "$out/bin/dcv"
  '';

  build-system = [
    pythonRelaxDepsHook
    setuptools-scm
  ];

  dependencies = [
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
    flufl-lock
    funcy
    grandalf
    gto
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
    zc-lockfile
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
    azure = [
      dvc-azure
    ];
    gdrive = [
      dvc-gdrive
    ];
    gs = [
      dvc-gs
    ];
    hdfs = [
      dvc-hdfs
    ];
    s3 = [
      dvc-s3
    ];
    ssh = [
      dvc-ssh
    ];
  };

  # Tests require access to real cloud services
  doCheck = false;

  pythonImportsCheck = [
    "dvc"
    "dvc.api"
  ];

  meta = with lib; {
    description = "Version Control System for Machine Learning Projects";
    homepage = "https://dvc.org";
    changelog = "https://github.com/iterative/dvc/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ cmcdragonkai fab ];
    mainProgram = "dvc";
  };
}
