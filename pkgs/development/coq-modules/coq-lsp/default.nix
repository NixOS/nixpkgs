{ lib, mkCoqDerivation, coq, serapi, makeWrapper, version ? null }:

(mkCoqDerivation rec {
  pname = "coq-lsp";
  owner = "ejgallego";
  namePrefix = [ ];

  useDune = true;

  release."0.1.8+8.16".sha256 = "sha256-dEEAK5IXGjHB8D/fYJRQG/oCotoXJuWLxXB0GQlY2eo=";
  release."0.1.9+8.17".sha256 = "sha256-BCsVRKSE9txeKgDfTsu7hQ6MebC+dX2AAqDF9iL7bYE=";
  release."0.2.0+8.18".sha256 = "sha256-OByBB1CLmj2N0AEieBXLVvP6OLGqi0HXra2jE9k3hXU=";
  release."0.2.0+8.19".sha256 = "sha256-G/UurWHxR2VzjClZCDHYcz7wAQAaYZt+DsADSXMybdk=";
  release."0.2.0+8.20".sha256 = "sha256-+KRiYK+YCHC4R6/yDenRI8SqZiZ29X24xlDzegbPfrw=";

  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
    { case = isEq "8.16"; out = "0.1.8+8.16"; }
    { case = isEq "8.17"; out = "0.1.9+8.17"; }
    { case = isEq "8.18"; out = "0.2.0+8.18"; }
    { case = isEq "8.19"; out = "0.2.0+8.19"; }
    { case = isEq "8.20"; out = "0.2.0+8.20"; }
  ] null;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    dune install -p ${pname} --prefix=$out --libdir $OCAMLFIND_DESTDIR
    wrapProgram $out/bin/coq-lsp --prefix OCAMLPATH : $OCAMLPATH
    runHook postInstall
  '';

  propagatedBuildInputs =
    with coq.ocamlPackages; [ dune-build-info menhir uri yojson ];

  meta = with lib; {
    description = "Language Server Protocol and VS Code Extension for Coq";
    homepage = "https://github.com/ejgallego/coq-lsp";
    changelog = "https://github.com/ejgallego/coq-lsp/blob/${defaultVersion}/CHANGES.md";
    maintainers = with maintainers; [ alizter ];
    license = licenses.lgpl21Only;
  };
}).overrideAttrs (o:
  with coq.ocamlPackages;
  { propagatedBuildInputs = o.propagatedBuildInputs ++
    (if o.version != null && lib.versions.isLe "0.1.9+8.19" o.version && o.version != "dev" then
     [ camlp-streams serapi ]
    else
     [ cmdliner ppx_deriving ppx_deriving_yojson ppx_import ppx_sexp_conv
       ppx_compare ppx_hash sexplib ]);
})
