{
  stdenv,
  lib,
  fetchFromGitLab,
  ocaml,
  findlib,
  camlp4,
  config-file,
  lablgtk,
  xmlm,
}:

stdenv.mkDerivation rec {
  version = "1.6";
  pname = "ocaml${ocaml.version}-lablgtk-extras";
  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "zoggy";
    repo = "lablgtk-extras";
    rev = "release-${version}";
    sha256 = "1bbdp5j18s582mmyd7qiaq1p08g2ag4gl7x65pmzahbhg719hjda";
  };

  strictDeps = true;

  nativeBuildInputs = [
    ocaml
    findlib
    camlp4
  ];
  propagatedBuildInputs = [
    config-file
    lablgtk
    xmlm
  ];

  createFindlibDestdir = true;

  meta = {
    inherit (ocaml.meta) platforms;
    maintainers = with lib.maintainers; [ vbgl ];
    homepage = "https://framagit.org/zoggy/lablgtk-extras/";
    description = "Collection of libraries and modules useful when developing OCaml/LablGtk2 applications";
    license = lib.licenses.lgpl2Plus;
    broken = lib.versionOlder ocaml.version "4.02" || lib.versionAtLeast ocaml.version "4.13";
  };
}
