{ stdenv, fetchurl, gettext }:

stdenv.mkDerivation rec {
  name = "attr-2.4.44";

  src = fetchurl {
    url = "mirror://savannah/attr/${name}.src.tar.gz";
    sha256 = "16244r2vrd57i5fnf7dz3yi2mcckc47jr9y539jvljrzwnw18qlz";
  };

  buildNativeInputs = [gettext];

  configureFlags = "MAKE=make MSGFMT=msgfmt MSGMERGE=msgmerge XGETTEXT=xgettext ECHO=echo SED=sed AWK=gawk";

  installTargets = "install install-lib install-dev";

  meta = {
    homepage = http://savannah.nongnu.org/projects/attr/;
    description = "Library and tools for manipulating extended attributes";
  };
}
