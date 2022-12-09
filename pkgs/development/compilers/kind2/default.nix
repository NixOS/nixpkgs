{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "kind2";
  version = "0.2.79";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-QRPk7BpGVvhGHcDxCWJtJp5d3QOq72ESt5VbaSq5jBU=";
  };

  cargoSha256 = "sha256-i7RAJmhUQzjMe9w7z7hPrpiap64L12Shu4DL+e5A6oc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  # these tests are flaky
  checkFlags = [
    "--skip=test_checker"
    "--skip=test_run_hvm"
  ];

  meta = with lib; {
    description = "A functional programming language and proof assistant";
    homepage = "https://github.com/kindelia/kind2";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
