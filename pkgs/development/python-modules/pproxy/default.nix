{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pycryptodome,
  uvloop,
  asyncssh,
  aioquic,
  python-daemon,
  setuptools,
  psycopg,
}:

buildPythonPackage rec {
  pname = "pproxy";
  version = "2.7.0"; # Test psycopg on upgrade!
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qwj";
    repo = "python-proxy";
    tag = version;
    hash = "sha256-2laRO7G85VIpRI5D7J5Z7PhTvmOXhUgWVx3G/Wtpc4I=";
  };

  nativeBuildInputs = [ setuptools ];

  optional-dependencies = {
    accelerated = [
      pycryptodome
      uvloop
    ];
    sshtunnel = [ asyncssh ];
    quic = [ aioquic ];
    daemon = [ python-daemon ];
  };

  nativeCheckInputs = lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "pproxy" ];

  disabledTests = [
    # Tests try to connect to outside Internet, so disabled
    "api_server"
    "api_client"
  ];

  # test suite doesn't use test runner. so need to run ``python ./tests/*``
  checkPhase = ''
    shopt -s extglob
    for f in ./tests/!(${builtins.concatStringsSep "|" disabledTests}).py ; do
      echo "***Testing $f***"
      eval "python $f"
    done
  '';

  passthru.tests = {
    inherit psycopg;
  };

  meta = {
    description = "Proxy server that can tunnel among remote servers by regex rules";
    mainProgram = "pproxy";
    homepage = "https://github.com/qwj/python-proxy";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ryand56 ];
  };
}
