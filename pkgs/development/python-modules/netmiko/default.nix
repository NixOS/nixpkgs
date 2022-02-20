{ lib, buildPythonPackage, fetchPypi, setuptools, paramiko, scp, tenacity
, textfsm, ntc-templates, pyserial, pytestCheckHook, pyyaml }:

buildPythonPackage rec {
  pname = "netmiko";
  version = "3.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14s9c6ws32swizcmfdqmlkkk2yqw6071ybq3w94fhkl6jzfvkbdc";
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
