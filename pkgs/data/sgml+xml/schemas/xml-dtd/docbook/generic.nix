{ stdenv, fetchurl, unzip, src, name, postInstall ? "true", meta ? {}, findXMLCatalogs }:

assert unzip != null;

stdenv.mkDerivation {
  inherit src name postInstall;
  builder = ./builder.sh;
  nativeBuildInputs = [unzip];
  propagatedNativeBuildInputs = [ findXMLCatalogs ];

  meta = meta // {
    platforms = stdenv.lib.platforms.unix;
  };
}
