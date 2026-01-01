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
    sha256 = "cdd046142a4e0060f96a00eb13d82a5d9ebc0f2d7934393ed559bac773460a2c";
  };

  nativeBuildInputs = [ libkrb5 ];

  # No tests in archive
  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "Kerberos high-level interface";
    homepage = "https://pypi.org/project/kerberos/";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "Kerberos high-level interface";
    homepage = "https://pypi.org/project/kerberos/";
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    knownVulnerabilities = [ "CVE-2015-3206" ];
  };
}
