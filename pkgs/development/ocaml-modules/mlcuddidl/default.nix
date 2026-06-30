{
  stdenv,
  lib,
  fetchFromGitLab,
  ocaml,
  findlib,
  camlidl,
  m4
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ocaml${ocaml.version}-mlcuddidl";
  version = "3.0.8";

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

  nativeBuildInputs = [
    ocaml
    findlib
    camlidl
    m4
  ];

  buildInputs = [
    camlidl # otherwise, ocamlfind: Package `camlidl' not found
  ];

  strictDeps = true;

  env.NIX_CFLAGS_COMPILE = "-Wno-error=int-conversion";

  meta = {
    homepage = "https://pop-art.inrialpes.fr/people/bjeannet/mlxxxidl-forge/mlcuddidl/index.html";
    broken = lib.versionAtLeast ocaml.version "5.0";
  };
})
