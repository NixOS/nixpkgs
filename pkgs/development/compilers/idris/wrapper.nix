{ gmp, makeWrapper, gcc, runCommand, idris_plain}:

runCommand "idris-wrapper" {} ''
  source ${makeWrapper}/nix-support/setup-hook
  mkdir -p $out/bin
  ln -s ${idris_plain}/bin/idris $out/bin
      wrapProgram $out/bin/idris \
        --suffix NIX_CFLAGS_COMPILE : '"-I${gmp}/include -L${gmp}/lib"' \
        --suffix PATH : ${gcc}/bin
''
