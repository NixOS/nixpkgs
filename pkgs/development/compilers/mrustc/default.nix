{ lib, stdenv
, fetchFromGitHub
, zlib
}:

let
  version = "0.9";
  tag = "v${version}";
  rev = "15773561e40ca5c8cffe0a618c544b6cfdc5ad7e";
in

stdenv.mkDerivation rec {
  pname = "mrustc";
  inherit version;

  # Always update minicargo.nix and bootstrap.nix in lockstep with this
  src = fetchFromGitHub {
    owner = "thepowersgang";
    repo = "mrustc";
    rev = tag;
    sha256 = "194ny7vsks5ygiw7d8yxjmp1qwigd71ilchis6xjl6bb2sj97rd2";
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
    longDescription = ''
      In-progress alternative rust compiler, written in C++.
      Capable of building a fully-working copy of rustc,
      but not yet suitable for everyday use.
    '';
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ progval r-burns ];
    platforms = [ "x86_64-linux" ];
  };
}
