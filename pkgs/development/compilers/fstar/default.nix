{ lib, stdenv, fetchFromGitHub, z3, ocamlPackages, makeWrapper, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "fstar";
  version = "0.9.6.0";

  src = fetchFromGitHub {
    owner = "FStarLang";
    repo = "FStar";
    rev = "v${version}";
    sha256 = "0wix7l229afkn6c6sk4nwkfq0nznsiqdkds4ixi2yyf72immwmmb";
  };

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  buildInputs = with ocamlPackages; [
    z3 ocaml findlib batteries menhir stdint
    zarith camlp4 yojson pprint
    ulex ocaml-migrate-parsetree process ppx_deriving ppx_deriving_yojson ocamlbuild
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  preBuild = ''
    patchShebangs src/tools
    patchShebangs bin
  '';
  buildFlags = [ "-C" "src/ocaml-output" ];

  preInstall = ''
    mkdir -p $out/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib/fstarlib
  '';
  installFlags = [ "-C" "src/ocaml-output" ];
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
    platforms = with platforms; darwin ++ linux;
    maintainers = with maintainers; [ gebner ];
  };
}
