{ lib, stdenv, fetchFromGitLab, findlib, cargo, rustc, opaline }:

stdenv.mkDerivation rec {
  pname = "tezos-rust-libs";
  version = "1.0";

  src = fetchFromGitLab {
    owner = "tezos";
    repo = "tezos-rust-libs";
    rev = "v${version}";
    sha256 = "1ffkzbvb0ls4wk9205g3xh2c26cmwnl68x43gh6dm9z4xsic94v5";
  };

  buildInputs = [
    findlib
    cargo
    rustc
  ];

  buildPhase = ''
    mkdir .cargo
    mv cargo-config .cargo/config
    cargo build --target-dir target --release
  '';

  installPhase = ''
    ${opaline}/bin/opaline -prefix $out -libdir $OCAMLFIND_DESTDIR/lib -name tezos-rust-libs
  '';

  doCheck = true;

  meta = {
    homepage = "https://gitlab.com/tezos/tezos-rust-libs";
    description = "Tezos: all rust dependencies and their dependencies";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
