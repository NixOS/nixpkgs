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
  version = "0.1.88";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-VnVyTUOtoplt0Zd5VkCe/h85/Mqcz7lgeIiZVD+Vrxk=";
  };

  cargoSha256 = "sha256-4D63OEz7/2pJGPXiFEwl6ggaV2DNZcoN//BM7H0Sp7I=";

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
