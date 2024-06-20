{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  pexpect,
}:

buildPythonPackage rec {
  version = "0.1.1";
  pname = "delegator.py";

  src = fetchFromGitHub {
    owner = "amitt001";
    repo = "delegator.py";
    rev = "v${version}";
    sha256 = "17n9h3xzjsfxmwclh33vc4yg3c9yzh9hfhaj12kv5ah3fy8rklwb";
  };

  propagatedBuildInputs = [ pexpect ];

  # no tests in github or pypi
  doCheck = false;

  meta = with lib; {
    description = "Subprocesses for Humans 2.0";
    homepage = "https://github.com/amitt001/delegator.py";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
