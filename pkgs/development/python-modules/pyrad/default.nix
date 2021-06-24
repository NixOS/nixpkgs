{ buildPythonPackage, fetchFromGitHub, lib, netaddr, six, nose }:

buildPythonPackage rec {
  pname = "pyrad";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "pyradius";
    repo = pname;
    rev = version;
    sha256 = "0hy7999av47s8100afbhxfjb8phbmrqcv530xlvskndby4a8w94k";
  };

  propagatedBuildInputs = [ netaddr six ];
  checkInputs = [ nose ];

  checkPhase = ''
    nosetests -e testBind
  '';

  meta = with lib; {
    description = "Python RADIUS Implementation";
    homepage = "https://bitbucket.org/zzzeek/sqlsoup";
    license = licenses.mit;
    maintainers = [ maintainers.globin ];
  };
}
