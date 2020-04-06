{ lib
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "pylibacl";
  version = "0.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "060f375aeff90a16fbc3a827b7e234694ad636485d8ecd6654e01e1fc4ea3b37";
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
