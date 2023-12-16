{ lib, runCommand, junicode, texliveBasic }:
let
  texliveWithJunicode = texliveBasic.withPackages (p: [ p.xetex junicode ]);

  texTest = { tex, fonttype }:
    lib.attrsets.nameValuePair "${tex}-${fonttype}" (
      runCommand "junicode-test-${tex}-${fonttype}.pdf" {
          nativeBuildInputs = [ texliveWithJunicode ];
          inherit tex fonttype;
        } ''
        substituteAll ${./test.tex} test.tex
        HOME=$PWD $tex test.tex
        cp test.pdf $out
      '');
in
builtins.listToAttrs (
  map
    texTest
    (lib.attrsets.cartesianProductOfSets {
      tex = [ "xelatex" "lualatex" ];
      fonttype = [ "ttf" "otf" ];
    })
)
