{
  coq,
  coq-lsp,
  ocamlPackages,
  lib,
  mkCoqDerivation,
  version ? null,
  makeWrapper,
}:

mkCoqDerivation rec {
  pname = "coqfmt";
  owner = "toku-sa-n";

  inherit version;
  displayVersion.coqfmt = v: "master-${v}";

  release."master" = {
    rev = "c26ce64d6ad1a1c3cafee38ab4889ad3b68a5c33";
    sha256 = "sha256-4Q0z/KUHrJZKeKJDqa9mkxfy9LrGh2xPt561muUFYAY=";
  };
  namePrefix = [ ];

  useDune = true;

  defaultVersion =
    with lib.versions;
    lib.switch coq.version [
      {
        case = isEq "8.20";
        out = "master";
      }
    ] null;

  installPhase = ''
    runHook preInstall
    dune install -p ${pname} --prefix=$out --libdir $OCAMLFIND_DESTDIR
    wrapProgram $out/bin/coqfmt --prefix OCAMLPATH : $OCAMLPATH
    runHook postInstall
  '';

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = with ocamlPackages; [
    dune-build-info
    coq-lsp
  ];

  meta = {
    description = "CLI tool to format your Coq source code";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ DieracDelta ];
  };

}
