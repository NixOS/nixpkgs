{
  lib,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  setuptools,
}:

let
  test-vectors = callPackage ./vectors.nix { };
in
buildPythonPackage rec {
  pname = "pycryptodome";
  version = "4.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Legrandin";
    repo = "pycryptodome";
    tag = "v${version}";
    hash = "sha256-1ThtrGzKeKP+1iVEVRlnEh59+ArVCCtZpujafdxaf7k=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ test-vectors ];

  pythonImportsCheck = [ "Crypto" ];

  meta = {
    description = "Self-contained cryptographic library";
    homepage = "https://github.com/Legrandin/pycryptodome";
    changelog = "https://github.com/Legrandin/pycryptodome/blob/${src.tag}/Changelog.rst";
    license = with lib.licenses; [
      bsd2 # and
      asl20
    ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
