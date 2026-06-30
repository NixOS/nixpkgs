{
  lib,
  buildDunePackage,
  fetchFromGitLab,

  colibrilib,
  ocaml-flint,
  cmdliner,
  cudd,
  containers,
  dolmen,
  dolmen_loop,
  dolmen_type,
  dune-build-info,
  farith,
  gen,
  gmap,
  ocamlgraph,
  ocplib-simplex,
  ounit2,
  ppx_deriving,
  ppx_hash,
  ppx_here,
  ppx_inline_test,
  ppx_optcomp,
  patricia-tree,
  qcheck-core,
  re,
  trace,
  trace-tef,
  zarith,
  mlcuddidl,
}:

buildDunePackage (finalAttrs: {
  pname = "colibri2";
  version = "0.6";

  src = fetchFromGitLab {
    owner = "pub";
    repo = "colibrics";
    domain = "git.frama-c.com";
    tag = finalAttrs.version;
    hash = "sha256-xuPFXonA6O/G+14Y3eglBTAtauBPewyYX9OXfEIe/6g=";
  };

  checkInputs = [
    ounit2
  ];

  propagatedBuildInputs = [
    colibrilib
    ocaml-flint
    cmdliner
    containers
    dolmen
    dolmen_loop
    dolmen_type
    dune-build-info
    farith
    gen
    gmap
    ocamlgraph
    ocplib-simplex
    ppx_deriving
    ppx_hash
    ppx_here
    ppx_inline_test
    ppx_optcomp
    patricia-tree
    qcheck-core
    re
    trace
    trace-tef
    zarith
    mlcuddidl
  ];

  meta = {
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ luc65r ];
  };
})
