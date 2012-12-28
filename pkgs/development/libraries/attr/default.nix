{ stdenv, fetchurl, gettext }:

stdenv.mkDerivation rec {
  name = "attr-2.4.46";

  src = fetchurl {
    url = "mirror://savannah/attr/${name}.src.tar.gz";
    sha256 = "07qf6kb2zk512az481bbnsk9jycn477xpva1a726n5pzlzf9pmnw";
  };

  nativeBuildInputs = [ gettext ];

  configureFlags = "MAKE=make MSGFMT=msgfmt MSGMERGE=msgmerge XGETTEXT=xgettext ECHO=echo SED=sed AWK=gawk";

  installTargets = "install install-lib install-dev";

  meta = {
    homepage = http://savannah.nongnu.org/projects/attr/;
    description = "Library and tools for manipulating extended attributes";
  };
}
