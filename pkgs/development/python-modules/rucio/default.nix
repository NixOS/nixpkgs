{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  alembic,
  argcomplete,
  boto3,
  dogpile-cache,
  flask,
  geoip2,
  gfal2-python,
  google-auth,
  jsonschema,
  oic,
  paramiko,
  prometheus-client,
  pymemcache,
  python-dateutil,
  python-magic,
  redis,
  requests,
  sqlalchemy,
  statsd,
  stomp-py,
  tabulate,
  urllib3,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rucio";
  version = "32.8.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rucio";
    repo = "rucio";
    tag = version;
    hash = "sha256-VQQ4gy9occism1WDrlcHnB7b7D5/G68wKct2PhD59FA=";
  };

  pythonRelaxDeps = [
    "alembic"
    "argcomplete"
    "boto3"
    "dogpile.cache"
    "flask"
    "geoip2"
    "google-auth"
    "jsonschema"
    "oic"
    "paramiko"
    "prometheus_client"
    "python-dateutil"
    "redis"
    "requests"
    "sqlalchemy"
    "stomp.py"
    "urllib3"
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    alembic
    argcomplete
    boto3
    dogpile-cache
    flask
    geoip2
    gfal2-python # needed for rucio download
    google-auth
    jsonschema
    oic
    paramiko
    prometheus-client
    pymemcache
    python-dateutil
    python-magic
    redis
    requests
    sqlalchemy
    statsd
    stomp-py
    tabulate
    urllib3
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  doCheck = false; # needs a rucio.cfg

  pythonImportsCheck = [ "rucio" ];

  meta = {
    description = "Tool for Scientific Data Management";
    homepage = "http://rucio.cern.ch/";
    changelog = "https://github.com/rucio/rucio/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
