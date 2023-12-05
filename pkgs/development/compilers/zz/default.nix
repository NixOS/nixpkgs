{ lib, rustPlatform, fetchFromGitHub, makeWrapper, z3, pkgsHostTarget }:

let
  runtimeDeps = [
    z3
    pkgsHostTarget.targetPackages.stdenv.cc
  ];
in

rustPlatform.buildRustPackage rec {
  pname = "zz";
  version = "unstable-2021-05-04";

  # when updating, choose commit of the latest build on http://bin.zetz.it/
  src = fetchFromGitHub {
    owner = "zetzit";
    repo = "zz";
    rev = "18020b10b933cfe2fc7f2256b71e646889f9b1d2";
    sha256 = "01nlyyk1qxk76dq2hw3wpbjwkh27zzp6mpczjnxdpv6rxs7mc825";
  };

  nativeBuildInputs = [ makeWrapper ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rsmt2-0.11.0" = "sha256-RwNsS0zge8uOXmgzTvDwp8AD70NspIZq0LgW/v3yrpA=";
    };
  };

  postPatch = ''
    # remove search path entry which would reference /build
    sed -i '/env!("CARGO_MANIFEST_DIR")/d' src/lib.rs
  '';

  postInstall = ''
    mkdir -p "$out/share/zz"
    cp -r modules "$out/share/zz/"

    wrapProgram $out/bin/zz \
      --prefix PATH ":" "${lib.makeBinPath runtimeDeps}" \
      --suffix ZZ_MODULE_PATHS ":" "$out/share/zz/modules"
  '';

  meta = with lib; {
    description = "ZetZ a zymbolic verifier and tranzpiler to bare metal C";
    homepage = "https://github.com/zetzit/zz";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
