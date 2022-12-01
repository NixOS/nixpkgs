{ lib
, buildPythonPackage
, fetchFromGitHub
, oyaml
, packaging
, paramiko
, pexpect
, requests
}:

buildPythonPackage rec {
  pname = "fortiosapi";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "fortinet-solutions-cse";
    repo = pname;
    rev = "v${version}";
    sha256 = "0679dizxcd4sk1b4h6ss8qsbjb3c8qyijlp4gzjqji91w6anzg9k";
  };

  propagatedBuildInputs = [
    pexpect
    requests
    paramiko
    packaging
    oyaml
  ];

  # Tests require a local VM
  doCheck = false;
  pythonImportsCheck = [ "fortiosapi" ];

  meta = with lib; {
    description = "Python module to work with Fortigate/Fortios devices";
    homepage = "https://github.com/fortinet-solutions-cse/fortiosapi";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
