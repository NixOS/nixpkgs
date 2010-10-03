{ stdenv, fetchurl }: 

stdenv.mkDerivation {
  name = "openjpeg-1.2";
  
  src = fetchurl {
    url = http://www.openjpeg.org/openjpeg_v1_2.tar.gz;
    sha256 = "1i72i0hhssgg6vfkaw3gpwf5ld65g9s77ay8pxd4any1xy54qa90";
  };

  patchPhase = ''
    sed -i -e 's/-o root -g [^ ]\+//' Makefile Makefile.osx
  '';

  preInstall = ''
    export installFlags="PREFIX=$out"
  '';
  
  meta = {
    homepage = http://www.openjpeg.org/;
    description = "Open-source JPEG 2000 codec written in C language";
    license = "BSD";
    platforms = stdenv.lib.platforms.all;
  };
}
