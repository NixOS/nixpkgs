{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  version = "0.6.4";
  pyproject = true;
  pname = "i3-py";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-HjF5xqX0dhqtP/CFl4D/wx+nefWDLXiob4ysLNEg9Ok=";
  };

  build-system = [ setuptools ];

  # no tests in tarball
  doCheck = false;

  meta = {
    description = "Tools for i3 users and developers";
    homepage = "https://github.com/ziberna/i3-py";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
  };
})
