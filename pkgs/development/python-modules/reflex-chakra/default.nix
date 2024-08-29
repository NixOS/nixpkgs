{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  reflex,
}:

buildPythonPackage rec {
  pname = "reflex-chakra";
  version = "0.5.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "reflex-dev";
    repo = "reflex-chakra";
    rev = "refs/tags/v${version}";
    hash = "sha256-EEU2BdkAJ3jPGMUCfXprUIGTXRbOK+uFtoWmjrBsclY=";
  };

  build-system = [
    poetry-core
  ];

  buildInputs = [ reflex.sans-reverse-dependencies ];
  # ensuring we don't propagate this intermediate build
  disallowedReferences = [ reflex.sans-reverse-dependencies ];

  pythonImportsCheck = [
    "reflex_chakra"
  ];

  meta = {
    description = "Chakra Implementation in Reflex";
    homepage = "https://github.com/reflex-dev/reflex-chakra/";
    changelog = "https://github.com/reflex-dev/reflex-chakra/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pbsds ];
  };
}
