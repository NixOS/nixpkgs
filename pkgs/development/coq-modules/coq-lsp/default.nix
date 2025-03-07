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
  release."0.2.2+8.17".sha256 = "sha256-dWPAwePbfTf2t+ydSd1Cnr2kKTDbvedmxm2+Z6F5zuM=";
  release."0.2.2+8.18".sha256 = "sha256-0J/XaSvhnKHRlcWfG1xbUOyN4LDtK1SEahE9kpV7GK4=";
  release."0.2.2+8.19".sha256 = "sha256-E2zO2SOU3nmTFf1yA1gefyIWTViUGNTTJ4r6fZYl6UY=";
  release."0.2.2+8.20".sha256 = "sha256-9yHisA3YJ/KuolU53qcQAjuSIAZPY+4rnkWV9dpLc6c=";

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
        out = "0.2.2+8.17";
      }
      {
        case = isEq "8.18";
        out = "0.2.2+8.18";
      }
      {
        case = isEq "8.19";
        out = "0.2.2+8.19";
      }
      {
        case = isEq "8.20";
        out = "0.2.2+8.20";
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
          else
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
        );

      patches = lib.optional (lib.versions.isEq "0.1.8" o.version) ./coq-loader.patch;
    }
  )
