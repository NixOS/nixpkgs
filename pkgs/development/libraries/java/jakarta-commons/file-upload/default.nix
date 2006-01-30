{stdenv, fetchurl} :

stdenv.mkDerivation {
  name = "commons-fileupload-1.0";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/commons-fileupload-1.0.tar.gz;
    md5 = "5618b26b1a5c006d7236fb4465e907b6";
  };
}