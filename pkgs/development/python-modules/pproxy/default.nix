{ lib
, isPy27
, buildPythonPackage
, fetchFromGitHub
, pycryptodome
, uvloop
}:

buildPythonPackage rec {
  pname = "pproxy";
  version = "2.3.7";
  format = "setuptools";

  disabled = isPy27;

  # doesn't use tagged releases. Tests not in PyPi versioned releases
  src = fetchFromGitHub {
    owner = "qwj";
    repo = "python-proxy";
    rev = "7fccf8dd62204f34b0aa3a70fc568fd6ddff7728";
    sha256 = "1sl2i0kymnbsk49ina81yjnkxjy09541f7pmic8r6rwsv1s87skc";
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
