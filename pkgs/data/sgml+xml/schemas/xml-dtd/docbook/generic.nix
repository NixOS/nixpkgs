{ stdenv, fetchurl, unzip, src, name, postInstall ? "true", meta ? {} }:

assert unzip != null;

stdenv.mkDerivation {
  inherit src name postInstall meta;
  builder = ./builder.sh;
  buildInputs = [unzip];
}
