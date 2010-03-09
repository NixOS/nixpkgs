{stdenv, fetchurl, libtool, gettext}:

stdenv.mkDerivation {
  name = "attr-2.4.43";

  src = fetchurl {
    # The SGI site throws away old versions, so don't use it.
    url = mirror://gentoo/distfiles/attr_2.4.43-1.tar.gz;
    sha256 = "1gy5zspj8ynxv6q29r24d18cfvq06zirg1pxcdg27bg2ncrv4n6k";
  };

  buildNativeInputs = [gettext];
  buildInputs = [libtool];

  configureFlags = "MAKE=make LIBTOOL=libtool MSGFMT=msgfmt MSGMERGE=msgmerge XGETTEXT=xgettext ECHO=echo SED=sed AWK=gawk";

  installTargets = "install install-lib install-dev";

  meta = {
    homepage = ftp://oss.sgi.com/projects/xfs/cmd_tars/;
    description = "Library and tools for manipulating extended attributes";
  };
}
