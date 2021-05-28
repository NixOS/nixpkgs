{ lib, buildPythonPackage, fetchFromGitHub, requests }:

buildPythonPackage rec {
  pname = "pyvmomi";
  version = "7.0";

  src = fetchFromGitHub {
    owner = "vmware";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qqljrlc9h7kddx3xxc6479gk75fvaxspfikzjn6zj5mznsvfwj5";
  };

  # requires old version of vcrpy
  doCheck = false;

  propagatedBuildInputs = [ requests ];

  meta = with lib; {
    description = "Python SDK for the VMware vSphere API that allows you to manage ESX, ESXi, and vCenter";
    homepage = "https://github.com/vmware/pyvmomi";
    license = licenses.asl20;
  };
}
