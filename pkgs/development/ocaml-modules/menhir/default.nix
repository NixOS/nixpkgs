{ stdenv, fetchurl, ocaml, findlib
, version ? if stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.02" then "20160303" else "20140422"
}@args:

let
  sha256 =
  if version == "20140422" then "1ki1f2id6a14h9xpv2k8yb6px7dyw8cvwh39csyzj4qpzx7wia0d"
  else if version == "20160303" then "1q57x81483xkvbx6bqjx31d4c4lpy9fs3y7h3l8azrs9yi7r6c63"
  else throw ("menhir: unknown version " ++ version);
in

import ./generic.nix (args // { inherit version sha256; })
