{ stdenv, fetchurl, ocaml, findlib, ocamlbuild
, version ? if stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.02" then "20180530" else "20140422"
}@args:

let
  sha256 =
  if version == "20140422" then "1ki1f2id6a14h9xpv2k8yb6px7dyw8cvwh39csyzj4qpzx7wia0d"
  else if version == "20180530" then "18jsl2vq4w50nfi62f99h3nw0rsbckn7msk696w03xqcg4k27jx8"
  else throw ("menhir: unknown version " ++ version);
in

import ./generic.nix (args // { inherit version sha256; })
