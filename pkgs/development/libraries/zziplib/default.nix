{ fetchurl, stdenv, perl, python2, zip, xmlto, zlib }:

stdenv.mkDerivation rec {
  name = "zziplib-${version}";
  version = "0.13.66";

  src = fetchurl {
    url = "mirror://sourceforge/zziplib/zziplib13/${version}/${name}.tar.gz";
    sha256 = "0zdx0s19slzv79xplnr6jx0xjb01dd71jzpscf6vlj6k9ry8rcar";
  };

  patchPhase = ''
    sed -i -e s,--export-dynamic,, configure
  '';

  buildInputs = [ perl python2 zip xmlto zlib ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Library to extract data from files archived in a zip file";

    longDescription = ''
      The zziplib library is intentionally lightweight, it offers the ability
      to easily extract data from files archived in a single zip
      file.  Applications can bundle files into a single zip archive and
      access them.  The implementation is based only on the (free) subset of
      compression with the zlib algorithm which is actually used by the
      zip/unzip tools.
    '';

    license = with licenses; [ lgpl2Plus mpl11 ];

    homepage = http://zziplib.sourceforge.net/;

    maintainers = [ ];
    platforms = python2.meta.platforms;
  };
}
