{ lib, buildPythonPackage, fetchFromGitHub, twisted, ldaptor, configobj }:

buildPythonPackage rec {
  pname = "privacyidea-ldap-proxy";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "privacyidea";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-U2lg4zDQKn9FQ7O0zSLaijIkXKVjg8wi2ItueF4ACDU=";
  };

  propagatedBuildInputs = [ twisted ldaptor configobj ];

  pythonImportsCheck = [ "pi_ldapproxy" ];

  meta = with lib; {
    description = "LDAP Proxy to intercept LDAP binds and authenticate against privacyIDEA";
    homepage = "https://github.com/privacyidea/privacyidea-ldap-proxy";
    license = licenses.agpl3Only;
    maintainers = [ maintainers.globin ];
  };
}
