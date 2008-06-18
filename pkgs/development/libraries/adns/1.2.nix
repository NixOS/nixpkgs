{ stdenv, fetchurl, version, static }:

assert version == "1.2";

import ./default.nix
{
  inherit stdenv fetchurl static version;
  versionHash = "0jn03hz6q4r6x40cxc94n38mxxj45f73xqisi0sh7zmvixh3qhi2";
}
