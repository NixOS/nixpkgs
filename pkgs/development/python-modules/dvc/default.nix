{
  lib,
  attrs,
  buildPythonPackage,
  celery,
  colorama,
  configobj,
  dulwich,
  distro,
  dpath,
  dvc-azure,
  dvc-data,
  dvc-gdrive,
  dvc-gs,
  dvc-hdfs,
  dvc-http,
  dvc-oss,
  dvc-render,
  dvc-s3,
  dvc-ssh,
  dvc-studio-client,
  dvc-task,
  dvc-webdav,
  dvc-webhdfs,
  fetchFromGitHub,
  flatten-dict,
  flufl-lock,
  fsspec,
  funcy,
  grandalf,
  gto,
  hydra-core,
  importlib-metadata,
  importlib-resources,
  iterative-telemetry,
  kombu,
  networkx,
  omegaconf,
  packaging,
  pathspec,
  platformdirs,
  psutil,
  pydot,
  pygtrie,
  pyparsing,
  requests,
  rich,
  ruamel-yaml,
  scmrepo,
  setuptools-scm,
  shortuuid,
  shtab,
  tabulate,
  tomlkit,
  tqdm,
  typing-extensions,
  voluptuous,
  zc-lockfile,
  enableGoogle ? false,
  enableAWS ? false,
  enableAzure ? false,
  enableSSH ? false,
}:

buildPythonPackage (finalAttrs: {
  pname = "dvc";
  version = "3.66.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "dvc";
    tag = finalAttrs.version;
    hash = "sha256-IvO5JEM3P0ggmufrBFv7fUBwoKzNIgWMUnOo31rYJRk=";
  };

  pythonRelaxDeps = [
    "dvc-data"
    "platformdirs"
  ];

  postPatch = ''
    substituteInPlace dvc/analytics.py \
      --replace-fail 'enabled = not os.getenv(DVC_NO_ANALYTICS)' 'enabled = False'
    substituteInPlace dvc/daemon.py \
      --subst-var-by dvc "$out/bin/dvc"
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    attrs
    celery
    colorama
    configobj
    distro
    dpath
    dulwich
    dvc-data
    dvc-http
    dvc-render
    dvc-studio-client
    dvc-task
    flatten-dict
    flufl-lock
    fsspec
    funcy
    grandalf
    gto
    hydra-core
    iterative-telemetry
    kombu
    networkx
    omegaconf
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
  ++ lib.optionals enableGoogle finalAttrs.passthru.optional-dependencies.gs
  ++ lib.optionals enableAWS finalAttrs.passthru.optional-dependencies.s3
  ++ lib.optionals enableAzure finalAttrs.passthru.optional-dependencies.azure
  ++ lib.optionals enableSSH finalAttrs.passthru.optional-dependencies.ssh;

  optional-dependencies = {
    azure = [ dvc-azure ];
    gdrive = [ dvc-gdrive ];
    gs = [ dvc-gs ];
    hdfs = [ dvc-hdfs ];
    oss = [ dvc-oss ];
    s3 = [ dvc-s3 ];
    ssh = [ dvc-ssh ];
    ssh_gssapi = [ dvc-ssh ] ++ dvc-ssh.optional-dependencies.gssapi;
    webdav = [ dvc-webdav ];
    webhdfs = [ dvc-webhdfs ];
    webhdfs_kerberos = [ dvc-webhdfs ] ++ dvc-webhdfs.optional-dependencies.kerberos;
  };

  # Tests require access to real cloud services
  doCheck = false;

  pythonImportsCheck = [
    "dvc"
    "dvc.api"
  ];

  meta = {
    description = "Version Control System for Machine Learning Projects";
    homepage = "https://dvc.org";
    changelog = "https://github.com/iterative/dvc/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      cmcdragonkai
      fab
    ];
    mainProgram = "dvc";
  };
})
