{ lib, stdenv, fetchFromGitHub, z3, ocamlPackages, makeWrapper, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "fstar";
  version = "2021.07.24";

  src = fetchFromGitHub {
    owner = "FStarLang";
    repo = "FStar";
    rev = "v${version}";
    sha256 = "0h7q2zji1hpfg28d61lmv9jlhrcwn59asg3h78y7yagv7ky2rlwf";
  };

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  buildInputs = with ocamlPackages; [
    z3 ocaml findlib batteries menhir menhirLib stdint
    zarith sedlex_2 ppxlib yojson pprint fileutils process ppx_deriving ppx_deriving_yojson ocamlbuild
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  preBuild = ''
    patchShebangs src/tools
    patchShebangs bin
    substituteInPlace src/ocaml-output/Makefile \
      --replace '$(shell ../tools/get_commit)' '${src.rev}'
  '';

  enableParallelBuilding = true;

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
    platforms = with platforms; darwin ++ linux;
    maintainers = with maintainers; [ gebner ];
  };
}
