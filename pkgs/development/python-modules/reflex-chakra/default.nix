{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "reflex-chakra";
  version = "0.6.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "reflex-dev";
    repo = "reflex-chakra";
    rev = "refs/tags/v${version}";
    hash = "sha256-VMFCaJh7HA/bsOV1ONuPJCzhzpQrcppOnPIcIIpeaSs=";
  };

  pythonRemoveDeps = [
    # Circular dependency
    "reflex"
  ];

  build-system = [ poetry-core ];

  # pythonImportsCheck = [ "reflex_chakra" ];

  doCheck = false;

  meta = with lib; {
    description = "Chakra Implementation in Reflex";
    homepage = "https://github.com/reflex-dev/reflex-chakra";
    changelog = "https://github.com/reflex-dev/reflex-chakra/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
