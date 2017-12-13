{ lib, buildPythonPackage, fetchPypi, python
, pbr
, ldap
, coverage
, fixtures
, sphinx
, openstackdocstheme
, testrepository
, testresources
, testtools
}:

buildPythonPackage rec {
  pname = "ldappool";
  version = "2.1.0";

  src = fetchPypi {
    inherit version pname;
    sha256 = "1kx5l6ssxfk0h1s6bg0aydb67izdvhbmhqhvnz11jzr5zmzlxq7k";
  };

  # flake8 is pinned
  # hacking is not packaged
  postPatch = ''
    sed -i 's/pyldap/python-ldap/' requirements.txt
  '';
  preCheck = ''
    sed -i -e '/flake8-docstrings/d' -e '/hacking/d' test-requirements.txt
  '';

  propagatedBuildInputs = [ pbr ldap ];
  checkInputs = [ coverage fixtures sphinx openstackdocstheme testrepository testresources testtools ];

  meta = with lib; {
    description = "A simple connector pool for python-ldap and related LDAP libraries";
    homepage = "https://github.com/openstack/ldappool";
  };
}
