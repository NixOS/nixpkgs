{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ppx_expect,
  ppx_inline_test,
  ppx_protocol_conv,
  otoml,
  jingoo,
  ez_subst,
  ez_opam_file,
  ez_file,
  ez_cmdliner,
  directories,
  bos,
  fmt,
  omd,
  iso8601,
  menhir,
  menhirLib,
}:

buildDunePackage (finalAttrs: {
  pname = "drom";
  version = "0.9.3";

  minimalOCamlVersion = "4.14";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "drom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R/n3mVxMVJ1Fnmy+tU5gMngF9oFbdTEiils2hJGTWzk=";
  };

  nativeBuildInputs = [ menhir ];

  propagatedBuildInputs = [
    ppx_inline_test
    ppx_expect
    ppx_protocol_conv
    otoml
    jingoo
    ez_subst
    ez_opam_file
    ez_file
    ez_cmdliner
    directories
    bos
    fmt
    omd
    iso8601
    menhirLib
  ];

  dunePackages = [
    "drom"
    "drom_lib"
    "drom_toml"
  ];

  doCheck = true;

  meta = {
    description = "Drom is a wrapper over opam/dune in an attempt to provide a cargo-like user experience";
    homepage = "https://ocamlpro.github.io/drom/";
    license = lib.licenses.WITH lib.licenses.lgpl21Only lib.licenses.ocamlLgplLinkingException;
    maintainers = [ lib.maintainers.sempiternal-aurora ];
  };
})
