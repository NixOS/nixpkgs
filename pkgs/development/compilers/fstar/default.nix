{ lib, stdenv, fetchFromGitHub, z3, ocamlPackages, makeWrapper, installShellFiles }:

let
  # FStar requires sedlex < 2.4
  # see https://github.com/FStarLang/FStar/issues/2343
  sedlex-2_3 = ocamlPackages.sedlex_2.overrideAttrs (_: rec {
    pname = "sedlex";
    version = "2.3";
    src = fetchFromGitHub {
       owner = "ocaml-community";
       repo = "sedlex";
       rev = "v${version}";
       sha256 = "WXUXUuIaBUrFPQOKtZ7dgDZYdpEVnoJck0dkrCi8g0c=";
    };
  });
in

stdenv.mkDerivation rec {
  pname = "fstar";
  version = "2021.10.16";

  src = fetchFromGitHub {
    owner = "FStarLang";
    repo = "FStar";
    rev = "v${version}";
    sha256 = "03b693s7s7dzflv5qkf61gd8ji9bn6fq4pxd8pd3a6ppkwj6b5vc";
  };

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  buildInputs = [
    z3
    sedlex-2_3
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
