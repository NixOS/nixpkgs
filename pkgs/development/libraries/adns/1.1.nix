{ stdenv, fetchurl, version ? "1.1", static }:

assert version == "1.1";

import ./default.nix
{
  inherit stdenv fetchurl static version;
  versionHash = "02plci50c7svbq15284z40c5aglydzh2zp68dj4lnigaxr6vm5vn";
}
