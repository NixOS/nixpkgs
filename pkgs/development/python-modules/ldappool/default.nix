{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  name = "ldappool-${version}";
  version = "1.0";

  src = fetchPypi {
    pname = "ldappool";
    inherit version;
    sha256 = "1akmzf51cjfvmd0nvvm562z1w9vq45zsx6fa72kraqgsgxhnrhqz";
  };

  # Judging from SyntaxError
  disabled = isPy3k;

  meta = with lib; {
    homepage = "https://github.com/mozilla-services/ldappool";
  };
}
