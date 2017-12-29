{ stdenv, fetchurl, unzip, src, name, postInstall ? "true", meta ? {}, findXMLCatalogs }:

assert unzip != null;

stdenv.mkDerivation {
  inherit src name postInstall;
  builder = ./builder.sh;
  buildInputs = [unzip];
  propagatedBuildInputs = [ findXMLCatalogs ];

  meta = meta // {
    platforms = stdenv.lib.platforms.unix;
  };
}
