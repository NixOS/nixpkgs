{
  lib,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  gmp,
  setuptools,
}:

let
  test-vectors = callPackage ./vectors.nix { };
in
buildPythonPackage rec {
  pname = "pycryptodome";
  version = "3.23.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Legrandin";
    repo = "pycryptodome";
    tag = "v${version}";
    hash = "sha256-x8QkRBwM/H/n7yHGjE8UfBhOzkGr0PBixe9g4EuZLUg=";
  };

  postPatch = ''
    substituteInPlace lib/Crypto/Math/_IntegerGMP.py \
      --replace-fail 'load_lib("gmp"' 'load_lib("${gmp}/lib/libgmp.so.10"'
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ test-vectors ];

  pythonImportsCheck = [ "Crypto" ];

  meta = with lib; {
    description = "Self-contained cryptographic library";
    homepage = "https://github.com/Legrandin/pycryptodome";
    changelog = "https://github.com/Legrandin/pycryptodome/blob/${src.tag}/Changelog.rst";
    license = with licenses; [
      bsd2 # and
      asl20
    ];
    maintainers = with maintainers; [ fab ];
  };
}
