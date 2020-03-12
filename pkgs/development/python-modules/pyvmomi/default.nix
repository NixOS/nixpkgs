{ lib, buildPythonPackage, fetchFromGitHub, requests }:

buildPythonPackage rec {
  pname = "pyvmomi";
  version = "6.7.1.2018.12";

  src = fetchFromGitHub {
    owner = "vmware";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pgl95rbghidbyr8hndjzfzgb1yjchfcknlqgg3qbqvljnz9hfja";
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
