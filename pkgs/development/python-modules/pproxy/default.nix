{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pycryptodome,
  uvloop,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pproxy";
  version = "2.7.9";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "qwj";
    repo = "python-proxy";
    rev = "7fccf8dd62204f34b0aa3a70fc568fd6ddff7728";
    sha256 = "sha256-bOqDdNiaZ5MRi/UeF0hJwMs+rfQBKRsTmXrZ6ieIguo=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    pycryptodome
    uvloop
  ];

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

  meta = with lib; {
    description = "Proxy server that can tunnel among remote servers by regex rules";
    mainProgram = "pproxy";
    homepage = "https://github.com/qwj/python-proxy";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
