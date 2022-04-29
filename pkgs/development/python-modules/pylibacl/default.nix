{ lib
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "pylibacl";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "88a0a4322e3a62d797d61f96ec7f38d1c471c48a3cc3cedb32ab5c20aa98d9ff";
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
