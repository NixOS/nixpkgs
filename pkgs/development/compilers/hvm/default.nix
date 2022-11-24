{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "hvm";
  version = "0.1.89";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-xPF8HW4QFXLLjg2HO5Pl+uQ44XCdAHc6koVpVXxN6dE=";
  };

  cargoSha256 = "sha256-dDSmiMwDbVDfStXamQvOMBBO5MiuDFhgzWPx0oYwzcM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  # memory allocation of 34359738368 bytes failed
  doCheck = false;

  meta = with lib; {
    description = "A pure functional compile target that is lazy, non-garbage-collected, and parallel";
    homepage = "https://github.com/kindelia/hvm";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
