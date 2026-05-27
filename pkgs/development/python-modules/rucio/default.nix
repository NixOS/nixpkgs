{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  packaging,
  setuptools,
  wheel,

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
  rich,
  sqlalchemy,
  statsd,
  stomp-py,
  tabulate,
  typing-extensions,
  urllib3,

  # tests
  pytestCheckHook,
}:

let
  version = "39.4.2";

  src = fetchFromGitHub {
    owner = "rucio";
    repo = "rucio";
    tag = version;
    hash = "sha256-xLOSdpkBjku3AehH6n9+hT1HM5QCwr1Sh7KEQRHr7jg=";
  };
in
buildPythonPackage {
  pname = "rucio";
  inherit version src;
  pyproject = true;

  # future-1.0.0 not supported for interpreter python3.13
  disabled = pythonAtLeast "3.13";

  pythonRelaxDeps = true;

  pythonRemoveDeps = [ "boto" ];

  build-system = [
    packaging
    setuptools
    wheel
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
    packaging
    paramiko
    prometheus-client
    pymemcache
    python-dateutil
    python-magic
    redis
    requests
    rich
    sqlalchemy
    statsd
    stomp-py
    tabulate
    typing-extensions
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
