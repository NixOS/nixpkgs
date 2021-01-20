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
    sha256 = "0drvxb21y7p0aikcv3jx90vdcjk96kibf9x8qgxic2prxxd3f3q6";
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
