{
  lib,
  buildPythonPackage,
  fetchPypi,
  py4j,
}:

buildPythonPackage rec {
  pname = "python-ldap-test";
  version = "0.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qh9x3lncaldnw79fgpqbayichs8pbz8abr6pxb5qxbs7zrnyrwf";
  };

  propagatedBuildInputs = [ py4j ];

  # Tests needs java to be present in path
  doCheck = false;

  meta = with lib; {
    description = "Tool for testing code speaking with LDAP server";
    homepage = "https://github.com/zoldar/python-ldap-test";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
