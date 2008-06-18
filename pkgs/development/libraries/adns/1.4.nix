{ stdenv, fetchurl, version, static }:

assert version == "1.4";

import ./default.nix
{
  inherit stdenv fetchurl static version;
  versionHash = "1zm99i9fd5gfijd144ajngn6x73563355im79sqdi98pj6ir4yvi";
}
