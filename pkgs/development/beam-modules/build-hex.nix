{ stdenv, buildRebar3, fetchHex }:

{ name, version, sha256
, hexPkg ? name
, ... }@attrs:

with stdenv.lib;

let
  pkg = self: buildRebar3 (attrs // {

    src = fetchHex {
      pkg = hexPkg;
      inherit version;
      inherit sha256;
    };
  });
in
  fix pkg
