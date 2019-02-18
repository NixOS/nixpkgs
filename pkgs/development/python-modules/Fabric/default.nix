{ pkgs
, buildPythonPackage
, fetchPypi
, invoke
, paramiko
, cryptography
, pytest
, mock
, pytest-relaxed
}:

buildPythonPackage rec {
  pname = "fabric";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "93684ceaac92e0b78faae551297e29c48370cede12ff0f853cdebf67d4b87068";
  };

  propagatedBuildInputs = [ invoke paramiko cryptography ];
  checkInputs = [ pytest mock pytest-relaxed ];

  # ignore subprocess main errors (1) due to hardcoded /bin/bash
  checkPhase = ''
    rm tests/main.py
    pytest tests
  '';

  meta = with pkgs.lib; {
    description = "Pythonic remote execution";
    homepage    = https://www.fabfile.org/;
    license     = licenses.bsd2;
    maintainers = [ maintainers.costrouc ];
  };
}
