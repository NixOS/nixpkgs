{ stdenv, lib, fetchurl, ocamlPackages, mpfr, ppl }:

stdenv.mkDerivation rec {
  pname = "jasmin-compiler";
<<<<<<< HEAD
  version = "2023.06.1";

  src = fetchurl {
    url = "https://github.com/jasmin-lang/jasmin/releases/download/v${version}/jasmin-compiler-v${version}.tar.bz2";
    hash = "sha256-3+eIR8wkBlcUQVDsugHo/rHNHbE2vpE9gutp55kRY4Y=";
=======
  version = "2022.09.2";

  src = fetchurl {
    url = "https://github.com/jasmin-lang/jasmin/releases/download/v${version}/jasmin-compiler-v${version}.tar.bz2";
    hash = "sha256-CGKaFR9Ax0O7BaW42DwYS4Air7zo5fOY2ExHkMGdtqo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  sourceRoot = "jasmin-compiler-v${version}/compiler";

<<<<<<< HEAD
  nativeBuildInputs = with ocamlPackages; [ ocaml findlib dune_3 menhir camlidl cmdliner ];
=======
  nativeBuildInputs = with ocamlPackages; [ ocaml findlib ocamlbuild menhir camlidl ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [
    mpfr
    ppl
  ] ++ (with ocamlPackages; [
    apron
<<<<<<< HEAD
    yojson
  ]);

  propagatedBuildInputs = with ocamlPackages; [
    batteries
    menhirLib
    zarith
  ];

  outputs = [ "bin" "lib" "out" ];

  installPhase = ''
    runHook preInstall
    dune build @install
    dune install --prefix=$bin --libdir=$out/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib
    mkdir -p $lib/lib/jasmin/easycrypt
    cp ../eclib/*.ec $lib/lib/jasmin/easycrypt
=======
    batteries
    menhirLib
    yojson
    zarith
  ]);

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp jasminc.native $out/bin/jasminc
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    runHook postInstall
  '';

  meta = {
    description = "A workbench for high-assurance and high-speed cryptography";
    homepage = "https://github.com/jasmin-lang/jasmin/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "jasminc";
    platforms = lib.platforms.all;
  };
}
