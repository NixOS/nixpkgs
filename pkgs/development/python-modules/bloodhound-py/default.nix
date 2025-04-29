{
  lib,
  buildPythonPackage,
  dnspython,
  fetchPypi,
  impacket,
  ldap3,
  pycryptodome,
  setuptools,
}:

buildPythonPackage rec {
  pname = "bloodhound-py";
  version = "1.8.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "bloodhound";
    hash = "sha256-Ne0PH92isdeaTp2JHKvixVMJoydDru0W2IXz2An0CbM=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    dnspython
    impacket
    ldap3
    pycryptodome
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "bloodhound" ];

  meta = with lib; {
    description = "Python based ingestor for BloodHound, based on Impacket";
    mainProgram = "bloodhound-python";
    homepage = "https://github.com/dirkjanm/BloodHound.py";
    license = licenses.mit;
    maintainers = with maintainers; [ exploitoverload ];
  };
}
