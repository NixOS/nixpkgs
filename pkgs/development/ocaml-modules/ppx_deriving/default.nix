{
  lib,
  fetchurl,
  buildDunePackage,
  ocaml,
  findlib,
  cppo,
  ppxlib,
  ppx_derivers,
  result,
  ounit,
  ounit2,
  ocaml-migrate-parsetree,
  version ?
    if lib.versionAtLeast ppxlib.version "0.36" then
      "6.1.1"
    else if lib.versionAtLeast ppxlib.version "0.32" then
      "6.0.3"
    else if lib.versionAtLeast ppxlib.version "0.20" then
      "5.2.1"
    else if lib.versionAtLeast ppxlib.version "0.15" then
      "5.1"
    else
      "5.0",
}:

let
  hash =
    {
      "6.1.1" = "sha256-yR0epeFeaSii+JR9vRNbn3ZcwOLXK+JxQnmBr801DCQ=";
      "6.0.3" = "sha256-N0qpezLF4BwJqXgQpIv6IYwhO1tknkRSEBRVrBnJSm0=";
      "5.2.1" = "sha256:11h75dsbv3rs03pl67hdd3lbim7wjzh257ij9c75fcknbfr5ysz9";
      "5.1" = "sha256:1i64fd7qrfzbam5hfbl01r0sx4iihsahcwqj13smmrjlnwi3nkxh";
      "5.0" = "sha256:0fkzrn4pdyvf1kl0nwvhqidq01pnq3ql8zk1jd56hb0cxaw851w3";
    }
    ."${version}";
in

buildDunePackage rec {
  pname = "ppx_deriving";
  inherit version;

  src = fetchurl {
    url = "https://github.com/ocaml-ppx/ppx_deriving/releases/download/v${version}/ppx_deriving-${lib.optionalString (lib.versionOlder version "6.0") "v"}${version}.${
      if lib.versionAtLeast version "6.1.1" then "tar.gz" else "tbz"
    }";
    inherit hash;
  };

  strictDeps = true;

  nativeBuildInputs = [ cppo ];
  buildInputs = [
    findlib
  ];
  propagatedBuildInputs =
    lib.optional (lib.versionOlder version "5.2") ocaml-migrate-parsetree
    ++ [
      ppx_derivers
      ppxlib
    ]
    ++ lib.optional (lib.versionOlder version "6.0") result;

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [
    (if lib.versionAtLeast version "5.2" then ounit2 else ounit)
  ];

  meta = with lib; {
    description = "Library simplifying type-driven code generation on OCaml >=4.02";
    maintainers = [ maintainers.maurer ];
    license = licenses.mit;
  };
}
