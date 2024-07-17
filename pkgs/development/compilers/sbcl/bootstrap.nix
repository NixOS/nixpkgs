{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  cfg,
}:

stdenv.mkDerivation rec {
  pname = "sbcl-bootstrap";
  inherit (cfg) version;

  src = fetchurl {
    url = "mirror://sourceforge/project/sbcl/sbcl/${version}/sbcl-${version}-${cfg.system}-binary.tar.bz2";
    inherit (cfg) sha256;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -p src/runtime/sbcl $out/bin

    mkdir -p $out/share/sbcl
    cp -p src/runtime/sbcl $out/share/sbcl
    cp -p output/sbcl.core $out/share/sbcl
    mkdir -p $out/bin
    makeWrapper $out/share/sbcl/sbcl $out/bin/sbcl \
      --add-flags "--core $out/share/sbcl/sbcl.core"
  '';

  postFixup = lib.optionalString (!stdenv.isAarch32 && stdenv.isLinux) ''
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $out/share/sbcl/sbcl
  '';

  meta.sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
}
