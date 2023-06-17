{ cxx-rs, fetchFromGitHub, lib, rustPlatform, testers }:

rustPlatform.buildRustPackage rec {
  pname = "cxx-rs";
  version = "1.0.94";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = "cxx";
    rev = version;
    sha256 = "sha256-h6TmQyxhoOhaAWBZr9rRPCf0BE2QMBIYm5uTVKD2paE=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoBuildFlags = [
    "--workspace"
    "--exclude=demo"
  ];

  postBuild = ''
    cargo doc --release
  '';

  cargoTestFlags = [ "--workspace" ];

  outputs = [ "out" "doc" "dev" ];

  postInstall = ''
    mkdir -p $doc
    cp -r ./target/doc/* $doc

    mkdir -p $dev/include/rust
    install -D -m 0644 ./include/cxx.h $dev/include/rust
  '';

  passthru.tests.version = testers.testVersion {
    package = cxx-rs;
    command = "cxxbridge --version";
  };

  meta = with lib; {
    description = "Safe FFI between Rust and C++";
    homepage = "https://github.com/dtolnay/cxx";
    license = licenses.mit;
    maintainers = with maintainers; [ centromere ];
  };
}
