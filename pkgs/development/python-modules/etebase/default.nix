
{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, rustPlatform
, pkg-config
, rustfmt
, setuptools-rust
, openssl
, Security
, msgpack
, fetchpatch
}:

buildPythonPackage rec {
  pname = "etebase";
  version = "0.31.5";

  src = fetchFromGitHub {
    owner = "etesync";
    rev = "ac3e5138a2e18dc11f77d9a75f07d4b8dd8c4445";
    hash = "sha256-OSzOoL7o4rWYOK1OyxfpslOnNfnK5CKhdhiFEXz/WvY=";
    repo = "etebase-py";
  };

  patches = [
    # Update dependencies
    (fetchpatch {
      url = "https://github.com/thyol/etebase-py/commit/db5533f4c895b6e7fc287e68e1fdd1cc9ca02bba.patch";
      hash = "sha256-glKxAEk+19R3lANwplw54V0BDZxpgvgrF+POnJscv9k=";
    })
  ];

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "flapigen-0.6.0-pre8" = "sha256-8KBhVgHn+UtrEtBQJEVTrx+h4IqhKTn9Csx6yBAV0RQ=";
    };
  };

  format = "pyproject";

  nativeBuildInputs = [
    pkg-config
    rustfmt
    setuptools-rust
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  propagatedBuildInputs = [
    msgpack
  ];

  postPatch = ''
    # Use system OpenSSL, which gets security updates.
    substituteInPlace Cargo.toml \
      --replace ', features = ["vendored"]' ""
  '';

  pythonImportsCheck = [ "etebase" ];


  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://www.etebase.com/";
    description = "A Python client library for Etebase";
    license = licenses.bsd3;
    maintainers = with maintainers; [ _3699n ];
  };
}
