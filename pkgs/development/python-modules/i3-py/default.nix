{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  version = "0.6.4";
  format = "setuptools";
  pname = "i3-py";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HjF5xqX0dhqtP/CFl4D/wx+nefWDLXiob4ysLNEg9Ok=";
  };

  # no tests in tarball
  doCheck = false;

  meta = with lib; {
    description = "Tools for i3 users and developers";
    homepage = "https://github.com/ziberna/i3-py";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
