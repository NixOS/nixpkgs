{ lib
, buildDunePackage
, fetchFromGitHub
, fetchpatch
, ocaml

, ounit
, zarith
}:

buildDunePackage rec {
  pname = "rfc7748";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "burgerdev";
    repo = "ocaml-rfc7748";
    rev = "v${version}";
    sha256 = "sha256-mgZooyfxrKBVQFn01B8PULmFUW9Zq5HJfgHCSJSkJo4=";
  };

  # Compatibility with OCaml 5.0
  patches = fetchpatch {
    url = "https://github.com/burgerdev/ocaml-rfc7748/commit/f66257bae0317c7b24c4b208ee27ab6eb68460e4.patch";
    hash = "sha256-780yy8gLOwwf7xIKIIIaoGpDPcY7+dZ0jPS4nrkH2s8=";
  };

  minimalOCamlVersion = "4.05";

  propagatedBuildInputs = [ zarith ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ ounit ];

  meta = {
    homepage = "https://github.com/burgerdev/ocaml-rfc7748";
    description = "Elliptic Curve Diffie-Hellman on Edwards Curves (X25519, X448)";
    longDescription = ''
      This library implements the ECDH functions 'X25519' and 'X448' as specified
      in RFC 7748, 'Elliptic curves for security'. In the spirit of the original
      publications, the public API is kept as simple as possible to make it easy
      to use and hard to misuse.
    '';
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fufexan ];
  };
}
