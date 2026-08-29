{
  stdenv,
  lib,
  fetchFromGitLab,
  ocaml,
  findlib,
  camlidl,
  m4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ocaml${ocaml.version}-mlcuddidl";
  version = "3.0.8";

  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "nberth";
    repo = "mlcuddidl";
    domain = "framagit.org";
    tag = finalAttrs.version;
    hash = "sha256-2tyZ1O8XARsJwU/+R7nM18hIPMYPk5JgbqgIzM9Xzfg=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '-ccopt "' '-ccopt="'
    substituteInPlace ocamlpack \
      --replace-fail '/bin/rm' 'rm'
  '';

  postConfigure = ''
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/stublibs
  '';

  strictDeps = true;

  nativeBuildInputs = [
    ocaml
    findlib
    camlidl
    m4
  ];

  buildInputs = [
    camlidl # otherwise, ocamlfind: Package `camlidl' not found
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=int-conversion";

  meta = {
    description = "C library offering an interface to the CUDD BDD library for OCaml";
    homepage = "https://pop-art.inrialpes.fr/people/bjeannet/mlxxxidl-forge/mlcuddidl/index.html";
    license = with lib.licenses; [
      bsd3 # cudd
      lgpl21Only # mlcuddidl
    ];
    maintainers = with lib.maintainers; [ luc65r ];
    broken = lib.versionAtLeast ocaml.version "5.0";
  };
})
