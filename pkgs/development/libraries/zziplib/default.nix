{ fetchurl, stdenv, perl, python, zip, xmlto, zlib }:

stdenv.mkDerivation rec {
  name = "zziplib-0.13.58";

  src = fetchurl {
    url = "mirror://sourceforge/zziplib/${name}.tar.bz2";
    sha256 = "13j9f6i8rx0qd5m96iwrcha78h34qpfk5qzi7cv098pms6gq022m";
  };

  patchPhase = ''
    sed -i -e s,--export-dynamic,, configure
  '';

  buildInputs = [ perl python zip xmlto zlib ];

  doCheck = true;

  meta = {
    description = "Zziplib, a library to extract data from files archived in a zip file";

    longDescription = ''
      The zziplib library is intentionally lightweight, it offers the ability
      to easily extract data from files archived in a single zip
      file.  Applications can bundle files into a single zip archive and
      access them.  The implementation is based only on the (free) subset of
      compression with the zlib algorithm which is actually used by the
      zip/unzip tools.
    '';

    licenses = [ "LGPLv2+" "MPLv1.1" ];

    homepage = http://zziplib.sourceforge.net/;

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = python.meta.platforms;
  };
}
