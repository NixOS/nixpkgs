{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  oyaml,
  packaging,
  paramiko,
  pexpect,
  pythonOlder,
  requests,
  six,
}:

buildPythonPackage rec {
  pname = "fortiosapi";
  version = "1.0.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fortinet-solutions-cse";
    repo = "fortiosapi";
    tag = "v${version}";
    hash = "sha256-M71vleEhRYnlf+RSGT1GbCy5NEZaG0hWmJo01n9s6Rg=";
  };

  propagatedBuildInputs = [
    pexpect
    requests
    paramiko
    packaging
    oyaml
    six
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
