{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  callPackage,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tikz-uml";
  version = "2.0a";
  outputs = [
    "tex"
    "texdoc"
  ];
  src = fetchFromGitLab {
    domain = "plmlab.math.cnrs.fr";
    owner = "tikzuml";
    repo = "tikzuml";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eSD5wbL7jWCt4Pv8XBXcPqBPFmwdRIeIaZ0iex18sZo=";
  };

  # https://tikzuml.pages.math.cnrs.fr/userguide/requirements.html
  passthru.tlDeps =
    ps: with ps; [
      pgf # for tikz
      #ifthen is part of LaTeX
      xstring
      tools # for calc
      pgfopts
    ];

  # multiple-outputs.sh fails if $out is not defined
  preHook = ''
    out="''${tex-}"
  '';
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src/*.sty -t "$tex/tex/latex/${finalAttrs.pname}"
    install -Dm644 $src/doc/*.pdf -t "$texdoc/doc/tex/latex/${finalAttrs.pname}"

    runHook postInstall
  '';

  meta = {
    description = "TikZ extension to manage common UML diagrams";
    license = lib.licenses.lppl13c;
    homepage = "https://tikzuml.pages.math.cnrs.fr/";
    maintainers = [ lib.maintainers.haansn08 ];
  };

  passthru.tests.umlseqdiag = callPackage ./test.nix { tikz-uml = finalAttrs.finalPackage; };

  strictDeps = true;
  __structuredAttrs = true;
})
