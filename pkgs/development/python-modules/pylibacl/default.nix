{ lib
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "pylibacl";
  version = "0.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7UludMpUUtXUzr4j3yKepGJzWpZSi5+ijjzh96K+0xo=";
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
