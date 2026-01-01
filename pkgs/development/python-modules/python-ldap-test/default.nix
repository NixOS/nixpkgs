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

<<<<<<< HEAD
  meta = {
    description = "Tool for testing code speaking with LDAP server";
    homepage = "https://github.com/zoldar/python-ldap-test";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ psyanticy ];
=======
  meta = with lib; {
    description = "Tool for testing code speaking with LDAP server";
    homepage = "https://github.com/zoldar/python-ldap-test";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
