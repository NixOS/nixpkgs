{
  lib,
  fetchFromGitHub,
  ocamlPackages,
}:

ocamlPackages.buildDunePackage {
  pname = "zipperposition";
  version = "2.1-unstable-2024-02-08";

  src = fetchFromGitHub {
    owner = "sneeuwballen";
    repo = "zipperposition";
    rev = "050072e01d8539f9126993482b595e09f921f66a";
    hash = "sha256-GoZO2hRZgh1qydlR+Uq4TprcPG9s7ge1N0Z2ilQ5x/w=";
  };

  nativeBuildInputs = with ocamlPackages; [
    menhir
  ];

  propagatedBuildInputs = with ocamlPackages; [
    zarith
    containers
    containers-data
    msat
    iter
    mtime
    oseq
  ];

  buildPhase = ''
    runHook preBuild
    dune build -p logtk,libzipperposition,zipperposition,zipperposition-tools ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    dune install --prefix $out --libdir $OCAMLFIND_DESTDIR logtk libzipperposition zipperposition zipperposition-tools
    runHook postInstall
  '';

  doCheck = true;

  checkInputs = with ocamlPackages; [
    alcotest
    qcheck-core
    qcheck-alcotest
  ];

  checkPhase = ''
    runHook preCheck
    dune runtest -p logtk,libzipperposition,zipperposition,zipperposition-tools ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
    runHook postCheck
  '';

  meta = {
    description = "Superposition prover for full first order logic";
    homepage = "https://github.com/sneeuwballen/zipperposition";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.DieracDelta ];
    mainProgram = "zipperposition";
    platforms = lib.platforms.all;
  };
}
