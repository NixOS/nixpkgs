{stdenv, fetchurl, libtool, gettext}:

stdenv.mkDerivation {
  name = "attr-2.4.41";

  src = fetchurl {
    url = ftp://oss.sgi.com/projects/xfs/cmd_tars/attr_2.4.41-1.tar.gz;
    sha256 = "0dc286g8vr402aca6wg945sdm92bys8a142vrkwx6bkjz4bwz6gp";
  };

  buildInputs = [libtool gettext];
  
  configureFlags = "MAKE=make LIBTOOL=libtool MSGFMT=msgfmt MSGMERGE=msgmerge XGETTEXT=xgettext ECHO=echo SED=sed AWK=gawk";
  
  installTargets = "install install-lib install-dev";
}
