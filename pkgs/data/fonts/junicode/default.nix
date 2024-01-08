{ lib, stdenvNoCC, fetchzip, texlive, callPackage }:

stdenvNoCC.mkDerivation rec {
  pname = "junicode";
  version = "2.205";

  src = fetchzip {
    url = "https://github.com/psb1558/Junicode-font/releases/download/v${version}/Junicode_${version}.zip";
    hash = "sha256-/9vkc6Ic3xyfpKEE64dBpoVM/gcRsLnAcrZWie9lNa4=";
  };

  outputs = [ "out" "doc" "tex" "texdoc" ];

  patches = [ ./tex-font-path.patch ];

  postPatch = ''
    substituteInPlace TeX/junicode.sty \
      --replace '@@@opentype_path@@@' "$out/share/fonts/opentype/" \
      --replace '@@@truetype_path@@@' "$out/share/fonts/truetype/"
    substituteInPlace TeX/junicodevf.sty \
      --replace '@@@truetype_path@@@' "$out/share/fonts/truetype/"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm 444 -t $out/share/fonts/truetype TTF/*.ttf VAR/*.ttf
    install -Dm 444 -t $out/share/fonts/opentype OTF/*.otf
    install -Dm 444 -t $out/share/fonts/woff2 WOFF2/*.woff2

    install -Dm 444 -t $doc/share/doc/${pname}-${version} docs/*.pdf

    install -Dm 444 -t $tex/tex/latex/junicode TeX/junicode.sty
    install -Dm 444 -t $tex/tex/latex/junicodevf TeX/junicodevf.{sty,lua}

    install -Dm 444 -t $texdoc/doc/tex/latex/junicode TeX/junicode-package.pdf
    install -Dm 444 -t $texdoc/doc/tex/latex/junicodevf TeX/junicodevf-package.pdf

    cat >$texdoc/doc/tex/latex/junicode/nix-font-note.txt <<EOF
    The style file is patched to refer directly to the corresponding
    font files; thus, contrary to the documentation, the fonts
    do *not* have to be installed globally.
    EOF

    runHook postInstall
  '';

  passthru = {
    tlDeps = with texlive; [ xkeyval fontspec ];

    tests = callPackage ./tests.nix { };
  };

  meta = {
    homepage = "https://github.com/psb1558/Junicode-font";
    description = "A Unicode font for medievalists";
    maintainers = with lib.maintainers; [ ivan-timokhin ];
    license = lib.licenses.ofl;
  };
}
