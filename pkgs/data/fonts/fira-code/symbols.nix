{ stdenv, fira-code, python3, fontforge }:

let pythonEnv = python3.withPackages (p: [ p.fontforge ]);
in stdenv.mkDerivation {
  name = "fira-code-symbols-20191205";
  # https://gist.github.com/xieve/d5a01cc59896c3973cb16df9ba8d30d4
  src = ./fira_code_patch.py;

  nativeBuildInputs = [ fontforge pythonEnv fira-code ];

  phases = [ "buildPhase" "installPhase" ];

  buildPhase = ''
    python3 $src -o . ${fira-code}/share/fonts/opentype/*.otf
    '';

  installPhase = ''
    mkdir -p ${placeholder "out"}/share/fonts/opentype
    ls *.otf | sed s/FiraCode-// | xargs -I{} -n1 cp FiraCode-{} ${placeholder "out"}/share/fonts/opentype/FiraCodeSymbols-{}
  '';

  meta = with stdenv.lib; {
    description = "FiraCode unicode ligature glyphs in private use area";
    longDescription = ''
      FiraCode uses ligatures, which some editors don’t support.
      This addition adds them as glyphs to the private unicode use area.
      See https://github.com/tonsky/FiraCode/issues/211.

      Use https://gist.github.com/xieve/d5a01cc59896c3973cb16df9ba8d30d4 script
      to patch fira code with current version.
    '';
    license = licenses.ofl;
    maintainers = [ maintainers.Profpatsch maintainers.vonfry ];
    homepage = "https://github.com/tonsky/FiraCode/issues/211#issuecomment-239058632";
  };
}
