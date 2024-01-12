{ lib
, fetchPypi
, python3
}:
python3.pkgs.buildPythonPackage rec {
  pname = "bloodhound-py";
  version = "1.7.1";

  src = fetchPypi {
    inherit version;
    pname = "bloodhound";
    hash = "sha256-BryByUo9FCSrrJgXoXoVPBjpmh32I0xRoeKBsYj8nSE=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    impacket
    ldap3
    dnspython
  ];

  # the package has no tests
  doCheck = false;

  meta = with lib; {
    description = "Python based ingestor for BloodHound, based on Impacket.";
    homepage = "https://github.com/dirkjanm/BloodHound.py";
    license = licenses.mit;
    maintainers = with maintainers; [ exploitoverload ];
  };
}
