{ lib, buildPythonPackage, fetchFromGitHub, requests, six }:

buildPythonPackage rec {
  pname = "pyvmomi";
  version = "7.0.2";

  src = fetchFromGitHub {
    owner = "vmware";
    repo = pname;
    rev = "v${version}";
    sha256 = "0li6g72ps1vxjzqhz10n02fl6cs069173jd9y4ih5am7vwhrwgpa";
  };

  # requires old version of vcrpy
  doCheck = false;

  propagatedBuildInputs = [ requests six ];

  meta = with lib; {
    description = "Python SDK for the VMware vSphere API that allows you to manage ESX, ESXi, and vCenter";
    homepage = "https://github.com/vmware/pyvmomi";
    license = licenses.asl20;
  };
}
