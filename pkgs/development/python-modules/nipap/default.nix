{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build deps
  setuptools,
  docutils,

  # dependencies
  zipp,
  importlib-metadata,
  flask,
  flask-compress,
  flask-xml-rpc-re,
  flask-restx,
  requests,
  ipy,
  # indirect deps omitted: jinja2/markupsafe/werkzeug,
  parsedatetime,
  psutil,
  psycopg2,
  pyparsing,
  python-dateutil,
  pytz,
  pyjwt,
  tornado,

  # optional deps
  ## ldap
  python-ldap,
}:

buildPythonPackage rec {
  pname = "nipap";
  version = "0.32.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SpriteLink";
    repo = "NIPAP";
    tag = "v${version}";
    hash = "sha256-FnCHW/yEhWtx+2fU+G6vxz50lWC7WL3cYKYOQzmH8zs=";
  };

  sourceRoot = "${src.name}/nipap";

  pythonRelaxDeps = true; # deps are tightly specified by upstream

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'docutils==0.20.1' 'docutils'
  '';

  build-system = [
    setuptools
    docutils
  ];

  dependencies = [
    zipp
    importlib-metadata
    flask
    flask-compress
    flask-xml-rpc-re
    flask-restx
    requests
    ipy
    # indirect deps omitted: jinja2/markupsafe/werkzeug
    parsedatetime
    psutil
    psycopg2
    pyparsing
    python-dateutil
    pytz
    pyjwt
    tornado
  ];

  optional-dependencies = {
    ldap = [ python-ldap ];
  };

  doCheck = false; # tests require nose, /etc/nipap/nipap.conf and a running nipapd

  meta = {
    description = "Neat IP Address Planner";
    longDescription = ''
      NIPAP is the best open source IPAM in the known universe,
      challenging classical IP address management (IPAM) systems in many areas.
    '';
    homepage = "https://github.com/SpriteLink/NIPAP";
    changelog = "https://github.com/SpriteLink/NIPAP/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      lukegb
    ];
    platforms = lib.platforms.all;
  };
}
