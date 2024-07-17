{
  stdenv,
  lib,
  fetchurl,
  ocamlPackages,
  mpfr,
  ppl,
}:

stdenv.mkDerivation rec {
  pname = "jasmin-compiler";
  version = "2024.07.0";

  src = fetchurl {
    url = "https://github.com/jasmin-lang/jasmin/releases/download/v${version}/jasmin-compiler-v${version}.tar.bz2";
    hash = "sha256-jE1LSL/fW7RKE5GeVzYtw4aFxtzTiz7IasD5YwDm4HE=";
  };

  sourceRoot = "jasmin-compiler-v${version}/compiler";

  nativeBuildInputs = with ocamlPackages; [
    ocaml
    findlib
    dune_3
    menhir
    camlidl
    cmdliner
  ];

  buildInputs =
    [
      mpfr
      ppl
    ]
    ++ (with ocamlPackages; [
      angstrom
      apron
      yojson
    ]);

  propagatedBuildInputs = with ocamlPackages; [
    batteries
    menhirLib
    zarith
  ];

  outputs = [
    "bin"
    "lib"
    "out"
  ];

  installPhase = ''
    runHook preInstall
    dune build @install
    dune install --prefix=$bin --libdir=$out/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib
    mkdir -p $lib/lib/jasmin/easycrypt
    cp ../eclib/*.ec $lib/lib/jasmin/easycrypt
    runHook postInstall
  '';

  meta = {
    description = "Workbench for high-assurance and high-speed cryptography";
    homepage = "https://github.com/jasmin-lang/jasmin/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "jasminc";
    platforms = lib.platforms.all;
  };
}
