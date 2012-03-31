{ stdenv, fetchurl }: 

stdenv.mkDerivation {
  name = "openjpeg-1.5.0";
  
  src = fetchurl {
    url = http://openjpeg.googlecode.com/files/openjpeg-1.5.0.tar.gz;
    sha256 = "1kja6s9dk0hh7p9064kg69y6vninwyvpqi8cap92waj38jmqz469";
  };

  meta = {
    homepage = http://www.openjpeg.org/;
    description = "Open-source JPEG 2000 codec written in C language";
    license = "BSD";
    platforms = stdenv.lib.platforms.all;
  };
}
