{
  lib,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  gmp,
}:

let
  test-vectors = callPackage ./vectors.nix { };
in
buildPythonPackage rec {
  pname = "pycryptodome";
  version = "3.21.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Legrandin";
    repo = "pycryptodome";
    tag = "v${version}";
    hash = "sha256-4GnjHDYJY1W3n6lUtGfk5KDMQfe5NoKbYn94TTXYCDY=";
  };

  postPatch = ''
    substituteInPlace lib/Crypto/Math/_IntegerGMP.py \
      --replace 'load_lib("gmp"' 'load_lib("${gmp}/lib/libgmp.so.10"'
  '';

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
