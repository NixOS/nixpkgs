{
  lib,
  buildPythonPackage,
  fetchgit,
}:

buildPythonPackage {
  pname = "pyfantom";
  version = "unstable-2013-12-18";
  format = "setuptools";

  src = fetchgit {
    url = "http://git.ni.fr.eu.org/pyfantom.git";
    sha256 = "1m53n8bxslq5zmvcf7i1xzsgq5bdsf1z529br5ypmj5bg0s86j4q";
  };

  # No tests included
  doCheck = false;

  meta = with lib; {
    homepage = "https://pyfantom.ni.fr.eu.org/";
    description = "Wrapper for the LEGO Mindstorms Fantom Driver";
    license = licenses.gpl2;
  };
}
