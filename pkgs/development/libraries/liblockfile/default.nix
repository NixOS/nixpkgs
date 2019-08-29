{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  _name   = "liblockfile";
  version = "1.15";
  name    = "${_name}-${version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/libl/${_name}/${_name}_${version}.orig.tar.gz";
    sha256 = "04ml9isvdl72fbr1825x7jb680xp8aprdq4pag32ahyjqk909cmh";
  };

  preConfigure = ''
    sed -i -e 's/ -g [^ ]* / /' Makefile.in
  '';

  preInstall = ''
    mkdir -p $out/{bin,lib,include,man} $out/man/man{1,3}
  '';

  meta = {
    description = "Shared library with NFS-safe locking functions";
    homepage = http://packages.debian.org/unstable/libs/liblockfile1;
    license = stdenv.lib.licenses.gpl2Plus;

    maintainers = [ stdenv.lib.maintainers.bluescreen303 ];
    platforms = stdenv.lib.platforms.all;
  };
}
