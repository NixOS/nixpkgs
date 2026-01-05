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
  version = "1.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "bloodhound";
    hash = "sha256-n1+0jv73lrn2FMNhDVUPDJxgUATa2oRO4S5P7/xQyFw=";
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
