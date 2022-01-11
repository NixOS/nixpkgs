{ lib, buildPythonPackage, fetchFromGitHub, requests, six }:

buildPythonPackage rec {
  pname = "pyvmomi";
  version = "7.0.3";

  src = fetchFromGitHub {
    owner = "vmware";
    repo = pname;
    rev = "v${version}";
    sha256 = "07jwlbi3k5kvpmgygvpkhsnbdp9m2ndwqxk9k6kyzfszwcbdx4bk";
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
