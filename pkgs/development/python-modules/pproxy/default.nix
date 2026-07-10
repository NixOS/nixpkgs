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
}:

buildPythonPackage rec {
  pname = "pproxy";
  version = "2.7.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qwj";
    repo = "python-proxy";
    tag = version;
    hash = "sha256-DWxbU2LtXzec1T175cMVJuWuhnxWYhe0FH67stMyOTM=";
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

  meta = {
    description = "Proxy server that can tunnel among remote servers by regex rules";
    mainProgram = "pproxy";
    homepage = "https://github.com/qwj/python-proxy";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ryand56 ];
  };
}
