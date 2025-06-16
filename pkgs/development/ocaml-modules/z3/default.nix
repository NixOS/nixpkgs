{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  ocaml,
  findlib,
  zarith,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ocaml${ocaml.version}-z3";
  version = "4.15.0";

  src = fetchFromGitHub {
    owner = "Z3Prover";
    repo = "z3";
    tag = "z3-${finalAttrs.version}";
    hash = "sha256-fk3NyV6vIDXivhiNOW2Y0i5c+kzc7oBqaeBWj/JjpTM=";
  };

  postPatch = ''
    mkdir -p $OCAMLFIND_DESTDIR/stublibs
  '';

  enableParallelBuilding = true;
  strictDeps = true;

  nativeBuildInputs = [
    python3
    ocaml
    findlib
  ];

  propagatedBuildInputs = [ zarith ];

  configurePhase = ''
    runHook preConfigure

    ${python3.pythonOnBuildForHost.interpreter} \
      scripts/mk_make.py \
      --prefix=$out \
      --ml

    cd build

    runHook postConfigure
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    make -j $NIX_BUILD_CORES test
    ./test-z3 -a

    runHook postCheck
  '';

  postInstall = ''
    mv ${placeholder "out"}/lib/ocaml/${ocaml.version}/site-lib/Z3 ${placeholder "out"}/lib/ocaml/${ocaml.version}/site-lib/z3
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^z3-([0-9]+\\.[0-9]+\\.[0-9]+)$"
      ];
    };
  };

  meta = {
    description = "OCaml API for the Z3 Theorem Prover";
    homepage = "https://github.com/Z3Prover/z3";
    changelog = "https://github.com/Z3Prover/z3/releases/tag/z3-${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      thoughtpolice
      ttuegel
      numinit
      ethancedwards8
    ];
  };
})
