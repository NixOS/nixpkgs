{ stdenv, fetchurl, version ? "1.3", static }:

assert version == "1.3";

import ./default.nix
{
  inherit stdenv fetchurl static version;
  versionHash = "05hd7qspvlsac9bqzx86r5a1wv7x1zdmqx6pi3ddk094m0n4bqn6";
}
