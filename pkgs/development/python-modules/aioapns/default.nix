{
  lib,
  buildPythonPackage,
  fetchPypi,
  h2,
  pyjwt,
  pyopenssl,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioapns";
  version = "4.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-NxX6q/P6bAJA52N/RCfYjQiv3M6w3PuVbG0JtvSUJ/g=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    h2
    pyopenssl
    pyjwt
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aioapns" ];

  meta = {
    description = "Efficient APNs Client Library";
    homepage = "https://github.com/Fatal1ty/aioapns";
    changelog = "https://github.com/Fatal1ty/aioapns/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
