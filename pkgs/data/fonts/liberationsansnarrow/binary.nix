{stdenv, liberation_ttf_v1_binary}:

stdenv.mkDerivation rec {
  name = builtins.replaceStrings ["liberation-fonts"] ["liberationsansnarrow"] liberation_ttf_v1_binary.name;

  buildCommand = ''
    mkdir -p $out/share/fonts/truetype $out/share/doc/${name}
    cp ${liberation_ttf_v1_binary}/share/fonts/truetype/*Narrow*.ttf $out/share/fonts/truetype/
    cp ${liberation_ttf_v1_binary}/share/doc/*/*                     $out/share/doc/${name}
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1sp5zkl7734q4bf5fbssp8cnhd2j9zjsspb4bq1fjfllrcb3va28";

  inherit (liberation_ttf_v1_binary) meta;
}
