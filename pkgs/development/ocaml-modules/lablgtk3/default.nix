{ lib, fetchFromGitHub, fetchpatch, pkg-config, buildDunePackage, dune-configurator, gtk3, cairo2 }:

buildDunePackage rec {
  version = "3.1.2";
  pname = "lablgtk3";

  useDune2 = true;

  minimalOCamlVersion = "4.05";

  src = fetchFromGitHub {
    owner = "garrigue";
    repo = "lablgtk";
    rev = version;
    sha256 = "sha256:0b17w9qb1f02h3313cm62mrqlhwxficppzm72n7sf8mmwrylxbm7";
  };

  patches = [ (fetchpatch {
    name = "dune-project.patch";
    url = "https://raw.githubusercontent.com/ocaml/opam-repository/10a48cb9fab88f67f6cb70280e0fec035c32d41c/packages/lablgtk3/lablgtk3.3.1.2/files/dune-project.patch";
    sha256 = "03jf5hclqdq7iq84djaqcnfnnnd7z3hb48rr8n1gyxzjyx86b3fh";
  }) ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ gtk3 cairo2 ];

  meta = {
    description = "OCaml interface to GTK 3";
    homepage = "http://lablgtk.forge.ocamlcore.org/";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
