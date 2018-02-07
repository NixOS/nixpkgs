{ stdenv, fetchFromGitHub, z3, ocamlPackages, makeWrapper }:

stdenv.mkDerivation rec {
  name = "fstar-${version}";
  version = "0.9.5.0";

  src = fetchFromGitHub {
    owner = "FStarLang";
    repo = "FStar";
    rev = "v${version}";
    sha256 = "1pi2ny3kpmvm85x8w98anhjf0hp0wccc51m7v697qypn5cl4ydqk";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = with ocamlPackages; [
    z3 ocaml findlib batteries menhir stdint
    zarith camlp4 yojson pprint
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  preBuild = ''
    patchShebangs src/tools
    patchShebangs bin
  '';
  buildFlags = "-C src/ocaml-output";

  installFlags = "-C src/ocaml-output";

  postInstall = ''
    wrapProgram $out/bin/fstar.exe --prefix PATH ":" "${z3}/bin"
  '';

  meta = with stdenv.lib; {
    description = "ML-like functional programming language aimed at program verification";
    homepage = https://www.fstar-lang.org;
    license = licenses.asl20;
    platforms = with platforms; darwin ++ linux;
    maintainers = with maintainers; [ gebner ];
  };
}
