{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "onetimepad";
  version = "1.4";

  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-HqredtgDbhy3npRLdYdL/l7kBGpXHAckVk4XIVZcc/0=";
  };

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "onetimepad" ];

  meta = {
    description = "Hacky implementation of one-time pad";
    mainProgram = "onetimepad";
    homepage = "https://jailuthra.in/onetimepad";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
