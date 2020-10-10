{ lib
, buildPythonPackage
, fetchPypi
, ansible-base
}:

buildPythonPackage rec {
  pname = "ansible";
  version = "2.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ink65zi7ghxy14rxwc2g7ck7flj799zx769aihf811zmiiddb9s";
  };

  propagatedBuildInputs = [
    ansible-base
  ];

  meta = with lib; {
    description = "Ansible collections";
    homepage = "https://pypi.org/project/ansible/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ hexa ];
  };
}
