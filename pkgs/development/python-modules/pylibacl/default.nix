{ lib
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "pylibacl";
  version = "0.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c3xw1s5bh6jnsc0wwyxnn6kn6x6rpbmmi05ap1f81fyqlgrzgj0";
  };

  # ERROR: testExtended (tests.test_acls.AclExtensions)
  # IOError: [Errno 0] Error
  doCheck = false;

  buildInputs = with pkgs; [ acl ];

  meta = {
    description = "A Python extension module for POSIX ACLs, it can be used to query, list, add, and remove ACLs from files and directories under operating systems that support them";
    license = lib.licenses.lgpl21Plus;
  };
}
