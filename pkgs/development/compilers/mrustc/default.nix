{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
}:

let
  version = "0.11.2";
  tag = "v${version}";
  rev = "b6754f574f8846eb842feba4ccbeeecb10bdfacc";
in

stdenv.mkDerivation rec {
  pname = "mrustc";
  inherit version;

  # Always update minicargo.nix and bootstrap.nix in lockstep with this
  src = fetchFromGitHub {
    owner = "thepowersgang";
    repo = "mrustc";
    rev = tag;
    hash = "sha256-HW9+2mXri3ismeNeaDoTsCY6lxeH8AELegk+YbIn7Jw=";
  };

  postPatch = ''
    sed -i 's/\$(shell git show --pretty=%H -s)/${rev}/' Makefile
    sed -i 's/\$(shell git symbolic-ref -q --short HEAD || git describe --tags --exact-match)/${tag}/' Makefile
    sed -i 's/\$(shell git diff-index --quiet HEAD; echo $$?)/0/' Makefile
    sed '1i#include <limits>' -i src/trans/codegen_c.cpp
  '';

  strictDeps = true;
  buildInputs = [ zlib ];
  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp bin/mrustc $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Mutabah's Rust Compiler";
    mainProgram = "mrustc";
    longDescription = ''
      In-progress alternative rust compiler, written in C++.
      Capable of building a fully-working copy of rustc,
      but not yet suitable for everyday use.
    '';
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [
      progval
      r-burns
    ];
    platforms = [ "x86_64-linux" ];
  };
}
