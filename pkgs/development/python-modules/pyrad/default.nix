{ buildPythonPackage, fetchFromGitHub, lib, netaddr, six, nose }:

buildPythonPackage rec {
  pname = "pyrad";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "pyradius";
    repo = pname;
    rev = version;
    sha256 = "sha256-oqgkE0xG/8cmLeRZdGoHkaHbjtByeJwzBJwEdxH8oNY=";
  };

  propagatedBuildInputs = [ netaddr six ];
  checkInputs = [ nose ];

  checkPhase = ''
    nosetests -e testBind
  '';

  pythonImportsCheck = [ "pyrad" ];

  meta = with lib; {
    description = "Python RADIUS Implementation";
    homepage = "https://bitbucket.org/zzzeek/sqlsoup";
    license = licenses.bsd3;
    maintainers = [ maintainers.globin ];
  };
}
