{ stdenv, fetchurl, unzip, src, name, postInstall ? "true", meta ? {} }:

assert unzip != null;

stdenv.mkDerivation {
  inherit src name postInstall;
  builder = ./builder.sh;
  buildInputs = [unzip];

  meta = meta // {
    platforms = stdenv.lib.platforms.unix;
  };
}
