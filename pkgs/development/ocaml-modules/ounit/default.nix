{
  stdenv,
  ocaml,
  findlib,
  ounit2,
}:

stdenv.mkDerivation {
  pname = "ocaml${ocaml.version}-ounit";
  inherit (ounit2) version src;
  # ounit2 has other outputs than this package.
  meta = removeAttrs ounit2.meta [ "outputsToInstall" ];

  nativeBuildInputs = [ findlib ];
  propagatedBuildInputs = [ ounit2 ];

  strictDeps = true;

  dontBuild = true;

  createFindlibDestdir = true;

  installTargets = "install-ounit version='${ounit2.version}'";

}
