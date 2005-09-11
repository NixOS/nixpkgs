{stdenv, fetchurl} :

stdenv.mkDerivation {
  name = "commons-fileupload-1.0";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://apache.mirror.rokscom.nl/jakarta/commons/fileupload/binaries/commons-fileupload-1.0.tar.gz;
    md5 = "5618b26b1a5c006d7236fb4465e907b6";
  };
}