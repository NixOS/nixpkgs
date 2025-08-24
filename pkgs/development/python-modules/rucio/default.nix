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
  version = "37.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rucio";
    repo = "rucio";
    tag = version;
    hash = "sha256-PZ6g/ILs1ed+lxcH2GyV1YJyJqLgYb5/xQ31OXiXnBU=";
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
    changelog = "https://github.com/rucio/rucio/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
