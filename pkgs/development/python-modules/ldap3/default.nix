{ stdenv, fetchPypi, fetchFromGitHub, buildPythonPackage, pyasn1 }:

buildPythonPackage rec {
  version = "2.5.2";
  pname = "ldap3";

## This should work, but 2.5.2 has a weird tarball with empty source files
## where upstream repository has non-empty ones
# src = fetchPypi {
#   inherit pname version;
#   sha256 = "063dacy01mphc3n7z2qc2avykjavqm1gllkbvy7xzw5ihlqwhrrz";
# };
  src = fetchFromGitHub {
    owner = "cannatag";
    repo = pname;
    rev = "v${version}";
    sha256 = "0p5l4bhy6j2nvvlxz5zvznbaqb72x791v9la2jr2wpwr60mzz9hw";
  };

  propagatedBuildInputs = [ pyasn1 ];

  doCheck = false; # requires network

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/ldap3;
    description = "A strictly RFC 4510 conforming LDAP V3 pure Python client library";
    license = licenses.lgpl3;
  };
}
