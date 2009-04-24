{stdenv, fetchurl, gettext, attr, libtool}:

stdenv.mkDerivation {
  name = "acl-2.2.47";

  src = fetchurl {
    url = http://nixos.org/tarballs/acl_2.2.47-1.tar.gz;
    sha256 = "1j39g62fki0iyji9s62slgwdfskpkqy7rmjlqcnmsvsnxbxhc294";
  };

  buildInputs = [gettext attr libtool];

  configureFlags = "MAKE=make LIBTOOL=libtool MSGFMT=msgfmt MSGMERGE=msgmerge XGETTEXT=xgettext ZIP=gzip ECHO=echo SED=sed AWK=gawk";

  installTargets = "install install-lib install-dev";
}
