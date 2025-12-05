{
  fetchFromGitHub,
  buildDunePackage,
  topkg,
  findlib,
  ocamlbuild,
  ocaml,
}:

buildDunePackage (finalAttrs: {
  pname = "asetmap";
  version = "0.8.1";
  src = fetchFromGitHub {
    owner = "dbuenzli";
    repo = "asetmap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Vb2LReOPrJQWl8/5YqIXOM7CyQBNYSUFYnVGMG8McwY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    topkg
    findlib
    ocamlbuild
    ocaml
  ];
  buildInputs = [ topkg ];

  inherit (topkg) buildPhase installPhase;

  meta = { inherit (ocaml.meta) platforms; };
})
