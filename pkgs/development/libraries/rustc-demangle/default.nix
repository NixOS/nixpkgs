{ rustPlatform, fetchFromGitHub, lib, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "rustc-demangle";
  version = "0.1.20";

  src = fetchFromGitHub {
    owner = "alexcrichton";
    repo = pname;
    rev = version;
    sha256 = "sha256-elxclyuLmr3N66s+pR4/6OU98k1oXI2wKVJtzWPY8FI=";
  };

  cargoLock = {
    # generated using `cargo generate-lockfile` since repo is missing lockfile
    lockFile = ./Cargo.lock;
  };

  cargoBuildFlags = [ "-p" "rustc-demangle-capi" ];

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  postInstall = ''
    mkdir -p $out/lib
    cp target/${stdenv.hostPlatform.rust.rustcTargetSpec}/release/librustc_demangle.so $out/lib
    cp -R crates/capi/include $out
  '';

  meta = with lib; {
    description = "Rust symbol demangling";
    homepage = "https://github.com/alexcrichton/rustc-demangle";
    license = with licenses; [ asl20 mit ];
    # upstream supports other platforms, but maintainer can only test on linux
    platforms = platforms.linux;
    maintainers = with maintainers; [ _1000teslas ];
  };
}
