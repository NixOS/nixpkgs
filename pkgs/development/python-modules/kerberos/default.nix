{
  lib,
  buildPythonPackage,
  fetchPypi,
  libkrb5,
}:

buildPythonPackage rec {
  pname = "kerberos";
  version = "1.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zdBGFCpOAGD5agDrE9gqXZ68Dy15NDk+1Vm6x3NGCiw=";
  };

  nativeBuildInputs = [ libkrb5 ];

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "Kerberos high-level interface";
    homepage = "https://pypi.org/project/kerberos/";
    license = licenses.asl20;
    knownVulnerabilities = [ "CVE-2015-3206" ];
  };
}
