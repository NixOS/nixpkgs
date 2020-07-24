{ lib
, isPy27
, buildPythonPackage
, fetchFromGitHub
, pycryptodome
, uvloop
}:

buildPythonPackage rec {
  pname = "pproxy";
  version = "2.3.2";

  disabled = isPy27;

  # doesn't use tagged releases. Tests not in PyPi versioned releases
  src = fetchFromGitHub {
    owner = "qwj";
    repo = "python-proxy";
    rev = "818ab9cc10565789fe429a7be50ddefb9c583781";
    sha256 = "0g3cyi5lzakhs5p3fpwywbl8jpapnr8890zw9w45dqg8k0svc1fi";
  };

  propagatedBuildInputs = [
    pycryptodome
    uvloop
  ];

  pythonImportsCheck = [ "pproxy" ];
  disabledTests = [ "api_server" "api_client" ];  # try to connect to outside Internet, so disabled
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
    homepage = "https://github.com/qwj/python-proxy";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
