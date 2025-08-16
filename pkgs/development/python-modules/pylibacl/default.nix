{
  lib,
  buildPythonPackage,
  fetchPypi,
  pkgs,
}:

buildPythonPackage rec {
  pname = "pylibacl";
  version = "0.7.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nZ/7WA4MWC1d5ZgIf3X2lARYsjgQxhVSkUPGGxcr+SI=";
  };

  # ERROR: testExtended (tests.test_acls.AclExtensions)
  # IOError: [Errno 0] Error
  doCheck = false;

  buildInputs = with pkgs; [ acl ];

  meta = {
    description = "Python extension module for POSIX ACLs, it can be used to query, list, add, and remove ACLs from files and directories under operating systems that support them";
    license = lib.licenses.lgpl21Plus;
  };
}
