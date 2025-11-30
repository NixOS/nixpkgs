{
  lib,
  mkCoqDerivation,
  coq,
  serapi,
  makeWrapper,
  version ? null,
}:

(mkCoqDerivation rec {
  pname = "coq-lsp";
  owner = "ejgallego";
  namePrefix = [ ];

  useDune = true;

  release."0.1.8+8.16".sha256 = "sha256-dEEAK5IXGjHB8D/fYJRQG/oCotoXJuWLxXB0GQlY2eo=";
  release."0.2.3+8.17".sha256 = "sha256-s7GXRYxuCMXm0XpKAyEwYqolsVFcKHhM71uabqqK5BY=";
  release."0.2.3+8.18".sha256 = "sha256-0cEuMWuNJwfiPdc0aHKk3EQbkVRIbVukS586EWSHCgo=";
  release."0.2.3+8.19".sha256 = "sha256-0eQQheY2yjS7shifhUlVPLXvTmyvgNpx7deLWXBRTfA=";
  release."0.2.3+8.20".sha256 = "sha256-TUVS8jkgf1MMOOx5y70OaeZkdIgdgmyGQ2/zKxeplEk=";
  release."0.2.3+9.0".sha256 = "sha256-eZMM4gYRXQroEIKz6XlffyHNYryEF5dIeIoVbEulh6M=";
  release."0.2.4+8.20".sha256 = "sha256-mQxh2/Cb5hZ99TtqWYLpZ/BRPrm5GRDYPDfKlCTK9N4=";
  release."0.2.4+9.0".sha256 = "sha256-ICPdNxJODNqmUErdTkNk7s52MRuINWLbAPm0rmXFW18=";
  release."0.2.4+9.1".sha256 = "sha256-HNHA2vbX70oZkd4QtbP28UbTRXatqxJdxw1OWDVDE8U=";

  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.coq-version [
      {
        case = isEq "8.16";
        out = "0.1.8+8.16";
      }
      {
        case = isEq "8.17";
        out = "0.2.3+8.17";
      }
      {
        case = isEq "8.18";
        out = "0.2.3+8.18";
      }
      {
        case = isEq "8.19";
        out = "0.2.3+8.19";
      }
      {
        case = isEq "8.20";
        out = "0.2.4+8.20";
      }
      {
        case = isEq "9.0";
        out = "0.2.4+9.0";
      }
      {
        case = isEq "9.1";
        out = "0.2.4+9.1";
      }
    ] null;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    dune install -p ${pname} --prefix=$out --libdir $OCAMLFIND_DESTDIR
    wrapProgram $out/bin/coq-lsp --prefix OCAMLPATH : $OCAMLPATH
    runHook postInstall
  '';

  propagatedBuildInputs = with coq.ocamlPackages; [
    dune-build-info
    menhir
    result
    uri
    yojson
  ];

  meta = with lib; {
    description = "Language Server Protocol and VS Code Extension for Coq";
    homepage = "https://github.com/ejgallego/coq-lsp";
    changelog = "https://github.com/ejgallego/coq-lsp/blob/${defaultVersion}/CHANGES.md";
    maintainers = with maintainers; [ alizter ];
    license = licenses.lgpl21Only;
  };
}).overrideAttrs
  (
    o: with coq.ocamlPackages; {
      propagatedBuildInputs =
        o.propagatedBuildInputs
        ++ (
          if o.version != null && lib.versions.isLe "0.1.9+8.19" o.version && o.version != "dev" then
            [
              camlp-streams
              serapi
            ]
          else if o.version != null && lib.versions.isLe "0.2.3" o.version && o.version != "dev" then
            [
              cmdliner
              ppx_deriving
              ppx_deriving_yojson
              ppx_import
              ppx_sexp_conv
              ppx_compare
              ppx_hash
              sexplib
            ]
          else
            [
              cmdliner
              ppx_deriving_yojson
              ppx_hash
              ppx_import
              ppx_sexp_conv
              sexplib
              tyxml
            ]
        );

      patches = lib.optional (lib.versions.isEq "0.1.8" o.version) ./coq-loader.patch;
    }
  )
