{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "blockchain";
  version = "1.4.4";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-26o+67b4G0JFAFc52oAsVxsJ+Y2X62ZSCv2V2cyv6+I=";
  };

  postPatch = ''
    substituteInPlace blockchain/blockexplorer.py \
      --replace-fail "from past.builtins import basestring" "basestring = str"
  '';

  build-system = [ setuptools ];

  pythonRemoveDeps = [
    "enum-compat"
    "future"
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "blockchain" ];

  meta = {
    description = "Blockchain API library (v1)";
    homepage = "https://github.com/blockchain/api-v1-client-python";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
