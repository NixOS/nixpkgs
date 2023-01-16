{ lib
, stdenv
, fetchurl
, which
, python3
, curl
, xcbuild
, darwin
}:

stdenv.mkDerivation rec {
  pname = "julia-source-with-deps";
  version = "1.8.5";

  src = fetchurl {
    url = "https://github.com/JuliaLang/julia/releases/download/v${version}/julia-${version}-full.tar.gz";
    hash = "sha256-NVVAgKS0085S7yICVDBr1CrA2I7/nrhVkqV9BmPbXfI=";
  };

  nativeBuildInputs = [
    which
    python3
    curl
  ] ++ lib.optionals stdenv.isDarwin [
    xcbuild
    darwin.DarwinTools
  ];

  dontPatch = true;
  dontConfigure = true;
  # Ensure the move-docs.sh hook doesn't move the doc/ directory to share/doc/
  forceShare = [ "dummy" ];

  installPhase = ''
    mkdir -p $out
    cp -r . "$out/."
  '';


  makeFlags = [ "julia-deps" ];
  # make julia-deps downloads dependencies from https://cache.julialang.org so this must be a fixed-output derivation
  outputHash = "0iva2m384vkvxbv8597ririwcmf600my5srn1cv041cscwkpzld5";
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";

  meta = with lib; {
    description = "High-level performance-oriented dynamical language for technical computing";
    homepage = "https://julialang.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
