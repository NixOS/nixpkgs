{ stdenv, lib, fetchurl, ocamlPackages, mpfr, ppl }:

stdenv.mkDerivation rec {
  pname = "jasmin-compiler";
  version = "2023.06.0";

  src = fetchurl {
    url = "https://github.com/jasmin-lang/jasmin/releases/download/v${version}/jasmin-compiler-v${version}.tar.bz2";
    hash = "sha256-yQBQGDNZQhNATs62nqWsgl/HzQCH24EHPp87B3I0Dxo=";
  };

  sourceRoot = "jasmin-compiler-v${version}/compiler";

  # Released tarball contains extraneous `dune` files
  # See https://github.com/jasmin-lang/jasmin/pull/495
  preBuild = ''
    rm -rf tests
  '';

  nativeBuildInputs = with ocamlPackages; [ ocaml findlib dune_3 menhir camlidl cmdliner ];

  buildInputs = [
    mpfr
    ppl
  ] ++ (with ocamlPackages; [
    apron
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
