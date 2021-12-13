{ lib, stdenv, fetchFromGitHub, z3, ocamlPackages, makeWrapper, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "fstar";
  version = "2021.11.27";

  src = fetchFromGitHub {
    owner = "FStarLang";
    repo = "FStar";
    rev = "v${version}";
    sha256 = "sha256-OpY7vDb37ym4srsmD+deXiuofUJKRyKXG7g3zsJKvHo=";
  };

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  buildInputs = [
    z3
  ] ++ (with ocamlPackages; [
    ocaml
    findlib
    ocamlbuild
    batteries
    zarith
    stdint
    yojson
    fileutils
    menhir
    menhirLib
    pprint
    sedlex_2
    ppxlib
    ppx_deriving
    ppx_deriving_yojson
    process
  ]);

  makeFlags = [ "PREFIX=$(out)" ];

  buildFlags = [ "libs" ];

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs ulib/gen_mllib.sh
    substituteInPlace src/ocaml-output/Makefile --replace '$(COMMIT)' 'v${version}'
  '';

  preInstall = ''
    mkdir -p $out/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib/fstarlib
  '';
  postInstall = ''
    wrapProgram $out/bin/fstar.exe --prefix PATH ":" "${z3}/bin"
    installShellCompletion --bash .completion/bash/fstar.exe.bash
    installShellCompletion --fish .completion/fish/fstar.exe.fish
    installShellCompletion --zsh --name _fstar.exe .completion/zsh/__fstar.exe
  '';

  meta = with lib; {
    description = "ML-like functional programming language aimed at program verification";
    homepage = "https://www.fstar-lang.org";
    license = licenses.asl20;
    changelog = "https://github.com/FStarLang/FStar/raw/v${version}/CHANGES.md";
    platforms = with platforms; darwin ++ linux;
    maintainers = with maintainers; [ gebner pnmadelaine ];
  };
}
