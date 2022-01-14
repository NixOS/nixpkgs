{ lib, buildPythonPackage, fetchFromGitHub, twisted, ldaptor, configobj }:

buildPythonPackage rec {
  pname = "privacyidea-ldap-proxy";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "privacyidea";
    repo = pname;
    rev = "v${version}";
    sha256 = "1i2kgxqd38xvb42qj0a4a35w4vk0fyp3n7w48kqmvrxc77p6r6i8";
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
