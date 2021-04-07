{ lib, buildPythonPackage, isPy3k, fetchFromGitHub, twisted, ldaptor, configobj }:

buildPythonPackage rec {
  pname = "privacyidea-ldap-proxy";
  version = "0.6.1";

  # https://github.com/privacyidea/privacyidea-ldap-proxy/issues/50
  disabled = isPy3k;

  src = fetchFromGitHub {
    owner = "privacyidea";
    repo = pname;
    rev = "v${version}";
    sha256 = "1kc1n9wr1a66xd5zvl6dq78xnkqkn5574jpzashc99pvm62dr24j";
  };

  propagatedBuildInputs = [ twisted ldaptor configobj ];

  # python 2 zope.interface test import path issues
  doCheck = false;

  pythonImportsCheck = [ "pi_ldapproxy" ];

  meta = with lib; {
    description = "LDAP Proxy to intercept LDAP binds and authenticate against privacyIDEA";
    homepage = "https://github.com/privacyidea/privacyidea-ldap-proxy";
    license = licenses.agpl3;
    maintainers = [ maintainers.globin ];
  };
}
