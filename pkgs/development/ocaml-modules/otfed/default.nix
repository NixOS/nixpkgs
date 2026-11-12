{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  fetchpatch,
  base,
  ppx_deriving,
  ppx_inline_test,
  uutf,
  alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "otfed";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "gfngfn";
    repo = "otfed";
    tag = finalAttrs.version;
    hash = "sha256-RxFLlI2qrM/7TmctNB3sPfqkYcZgsc1W3z36xzE5XXY=";
  };

  patches = [
    # Compatibility with alcotest 1.10
    (fetchpatch {
      url = "https://github.com/gfngfn/otfed/commit/2ace054bba629b80af9c70b4599a66a9eb0a33d0.patch";
      hash = "sha256-0zuHMghD4UuK42dii8J//q35+89y7MGBIDpI9yGPbRM=";
    })
  ];

  buildInputs = [
    uutf
  ];

  propagatedBuildInputs = [
    base
    ppx_deriving
    ppx_inline_test
  ];

  checkInputs = [
    alcotest
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/gfngfn/otfed";
    description = "OpenType Font Format Encoder & Decoder";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
