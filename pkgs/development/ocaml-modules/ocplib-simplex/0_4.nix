{
  lib,
  fetchFromGitHub,
  stdenv,
  autoreconfHook,
  ocaml,
  findlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ocplib-simplex";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-bhlTBpJg031x2lUjwuVrhQgOGmDLW/+0naN8wRjv6i4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    ocaml
    findlib
  ];

  preInstall = ''
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/
  '';

  postInstall = ''
    mv $out/lib/${finalAttrs.pname} $out/lib/ocaml/${ocaml.version}/site-lib
  '';

  meta = {
    description = "OCaml library implementing a simplex algorithm, in a functional style, for solving systems of linear inequalities";
    homepage = "https://github.com/OCamlPro/ocplib-simplex";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ redianthus ];
  };
})
