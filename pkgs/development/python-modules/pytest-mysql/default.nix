{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, mock
, mirakuru
, mysqlclient
, port-for
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-mysql";
  version = "2.0.1";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "ClearcodeHQ";
    repo = pname;
    rev = "v" + version;
    sha256 = "18z7br80hj46cnmj9jflbyzlgxxn5qmwqz7iqwsl4ynzipfx81hd";
  };
  
  propagatedBuildInputs = [ mirakuru mysqlclient port-for pytest ];
 
  checkInputs = [ mock pytest ];
 
  checkPhase = ''
    # deselect test_mysql.py because that requires a running mysqld 
    pytest tests -k 'not test_mysql.py'
  '';
 
  meta = with lib; {
    description = "MySQL process and client fixtures for pytest";
    homepage = "https://github.com/ClearcodeHQ/pytest-mysql";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
