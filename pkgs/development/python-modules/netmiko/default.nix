{ lib, buildPythonPackage, fetchPypi, setuptools, paramiko, scp, tenacity
, textfsm, ntc-templates, pyserial, pytestCheckHook, pyyaml }:

buildPythonPackage rec {
  pname = "netmiko";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fVhBkiO1JpqMIFl32xlwSjeCd7aObocXPAr069fKdmc=";
  };

  buildInputs = [ setuptools ];
  propagatedBuildInputs =
    [ paramiko scp tenacity textfsm ntc-templates pyserial ];

  # tests require closed-source pyats and genie packages
  doCheck = false;

  meta = with lib; {
    description =
      "Multi-vendor library to simplify Paramiko SSH connections to network devices";
    homepage = "https://github.com/ktbyers/netmiko/";
    license = licenses.mit;
    maintainers = [ maintainers.astro ];
  };
}
