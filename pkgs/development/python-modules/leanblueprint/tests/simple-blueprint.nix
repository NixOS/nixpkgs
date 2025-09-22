{
  stdenv,

  # dependencies
  git,
  texlive,
  texlivePackages,

  leanblueprint,
}:
stdenv.mkDerivation {
  name = "leanblueprint-test";
  src = ./blueprint/src;

  nativeBuildInputs = [
    leanblueprint
    git
    texlive.combined.scheme-small
    texlivePackages.latexmk
  ];

  buildPhase = ''
    runHook preBuild

    # A git repository is required by leanblueprint
    git init

    # A lakefile is required by leanblueprint
    echo > lakefile.lean

    # Copy minimal blueprint
    mkdir -p blueprint/src
    cp -r $src/. blueprint/src

    leanblueprint web
    leanblueprint pdf

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r blueprint/web $out
    cp -r blueprint/print $out
    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck
    grep -q "Leanblueprint Test" $out/web/index.html
    grep -q "Test Chapter" $out/web/index.html
    grep -q "Test Chapter" $out/web/sect0001.html
    grep -q "def:one_add_one_eq_two" $out/web/sect0001.html
    grep -q "sect0001.html#def:one_add_one_eq_two" $out/web/dep_graph_document.html
    test -d $out/web/js
    test -d $out/web/styles

    test -f $out/print/print.pdf
    runHook postCheck
  '';
}
