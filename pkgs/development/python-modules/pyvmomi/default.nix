{ lib, buildPythonPackage, fetchFromGitHub, requests, six }:

buildPythonPackage rec {
  pname = "pyvmomi";
  version = "8.0.0.1";

  src = fetchFromGitHub {
    owner = "vmware";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-DVqC5giVMixj9NlGJ2gaH7ybX3hdQsdNTjuTkesao9E=";
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
