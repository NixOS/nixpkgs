{
  lib,
  fetchPypi,
  openssl,
  buildPythonPackage,
  setuptools,
  pytestCheckHook,
  dnspython,
  pynacl,
  authres,
}:

buildPythonPackage (finalAttrs: {
  pname = "dkimpy";
  version = "1.1.8";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-tfYPtHu/XY12LxNLzqDDiOumtJg0KmgqIfFoZUUJS3c=";
  };

  build-system = [ setuptools ];

  dependencies = [
    openssl
    dnspython
    pynacl
    authres
  ];

  postPatch = ''
    substituteInPlace dkim/dknewkey.py --replace-fail \
      /usr/bin/openssl ${lib.getExe openssl}
  '';

  pythonImportsCheck = [ "dkim" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "DKIM + ARC email signing/verification tools + Python module";
    longDescription = ''
      Python module that implements DKIM (DomainKeys Identified Mail) email
      signing and verification. It also provides a number of convenient tools
      for command line signing and verification, as well as generating new DKIM
      records. This version also supports the experimental Authenticated
      Received Chain (ARC) protocol.
    '';
    homepage = "https://launchpad.net/dkimpy";
    license = lib.licenses.bsd3;
  };
})
