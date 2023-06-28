with import <nixpkgs> {};
#{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "cairo-lang";
  version = "2.0.0-rc6";

  src = fetchurl {
    url = "https://github.com/starkware-libs/cairo/archive/refs/tags/v${version}.tar.gz";
    sha256 = "e3dd3ce3f9ab5b69c44d01b13777d92516dcd830efb6a3d2cd46915d4f03e8a9";
  };

  buildInputs = [git rustup gcc libiconv];

  configurePhase = ''
    export HOME=$(pwd)
    rustup override set stable
    rustup update
  '';

  buildPhase = ''
    export HOME=$(pwd)
    cargo build --all --release --manifest-path ./Cargo.toml
  '';

  installPhase = ''
    mkdir -p $out/bin/

    mv "./target/release/cairo-compile" $out/bin/
    mv "./target/release/cairo-format" $out/bin/
    mv "./target/release/cairo-language-server" $out/bin/
    mv "./target/release/cairo-run" $out/bin/
    mv "./target/release/cairo-test" $out/bin/
    mv "./target/release/sierra-compile" $out/bin/
    mv "./target/release/starknet-compile" $out/bin/
    mv "./target/release/starknet-sierra-compile" $out/bin/
  '';

  meta = with lib; {
    description = "Cairo language instalation";
    homepage = "https://cairo-by-example.com/";
    sourceProvenance = with sourceTypes; [ fromSource ];
    license = licenses.mit;
    maintainers = with maintainers; [ samoht9277 ];
  };
}
