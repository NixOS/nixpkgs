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
  pname = "bloodhound-ce-py";
  version = "1.8.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "bloodhound_ce";
    hash = "sha256-9mPWGB4qGrjenVeUgBFmLipHiA2MrKm4U2mn767ROnA=";
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
    description = "Python based ingestor for BloodHound (Community Edition), based on Impacket";
    mainProgram = "bloodhound-ce-python";
    homepage = "https://github.com/dirkjanm/BloodHound.py";
    license = licenses.mit;
    maintainers = with maintainers; [ marv963 ];
  };
}
