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
  version = "3.20.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Legrandin";
    repo = "pycryptodome";
    rev = "refs/tags/v${version}";
    hash = "sha256-RPaBUj/BJCO+10maGDmugeEXxaIrlk2UHIvkbrQVM8c=";
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
    changelog = "https://github.com/Legrandin/pycryptodome/blob/v${version}/Changelog.rst";
    license = with licenses; [
      bsd2 # and
      asl20
    ];
    maintainers = with maintainers; [ fab ];
  };
}
