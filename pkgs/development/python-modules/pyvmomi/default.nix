{ lib, buildPythonPackage, fetchFromGitHub, requests, six }:

buildPythonPackage rec {
  pname = "pyvmomi";
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "vmware";
    repo = pname;
    rev = "v${version}";
    sha256 = "1i7zni4ygdikc22wfrbnzwqh6qy402s3di6sdlfcvky2y7fzx52x";
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
