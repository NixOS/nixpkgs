{ stdenv, fetchurl, ocaml, findlib, ocamlbuild
, version ? if stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.02" then "20170712" else "20140422"
}@args:

let
  sha256 =
  if version == "20140422" then "1ki1f2id6a14h9xpv2k8yb6px7dyw8cvwh39csyzj4qpzx7wia0d"
  else if version == "20170712" then "006hq3bwj81j67f2k9cgzj5wr4hai8j36925p5n3sd2j01ljsj6a"
  else throw ("menhir: unknown version " ++ version);
in

import ./generic.nix (args // { inherit version sha256; })
