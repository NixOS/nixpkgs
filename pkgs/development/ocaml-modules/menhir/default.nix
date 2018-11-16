{ stdenv, fetchurl, ocaml, findlib, ocamlbuild
, version ? if stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.02" then "20181026" else "20140422"
}@args:

let
  src = fetchurl (
  if version == "20140422" then { url = "http://cristal.inria.fr/~fpottier/menhir/menhir-20140422.tar.gz"; sha256 = "1ki1f2id6a14h9xpv2k8yb6px7dyw8cvwh39csyzj4qpzx7wia0d"; }
  else if version == "20170712" then { url = "http://gallium.inria.fr/~fpottier/menhir/menhir-20170712.tar.gz"; sha256 = "006hq3bwj81j67f2k9cgzj5wr4hai8j36925p5n3sd2j01ljsj6a"; }
  else if version == "20181026" then { url = "https://gitlab.inria.fr/fpottier/menhir/repository/20181026/archive.tar.gz"; sha256 = "1zhacw60996i9b88kbnfvrvjk3ps9p9n9syjk9np545jp8l0582g"; }
  else throw ("menhir: unknown version " ++ version)
  );
in

import ./generic.nix (args // { inherit version src; })
