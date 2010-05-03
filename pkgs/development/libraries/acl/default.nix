{stdenv, fetchurl, gettext, attr, libtool}:

stdenv.mkDerivation rec {
  name = "acl-2.2.49";

  src = fetchurl {
    url = "mirror://savannah/acl/${name}.src.tar.gz";
    sha256 = "1mg5nxr0r9y08lmyxmm2lfss5jz1xzbs0npsc8597x2f5rsz9ixr";
  };

  buildNativeInputs = [gettext];
  buildInputs = [attr libtool];

  # Upstream use C++-style comments in C code. Remove them.
  # This comment breaks compilation if too strict gcc flags are used.
  patchPhase = ''
    echo "Removing C++-style comments from include/acl.h"
    sed -e '/^\/\//d' -i include/acl.h
  '';

  configureFlags = "MAKE=make LIBTOOL=libtool MSGFMT=msgfmt MSGMERGE=msgmerge XGETTEXT=xgettext ZIP=gzip ECHO=echo SED=sed AWK=gawk";

  installTargets = "install install-lib install-dev";

  meta = {
    homepage = http://savannah.nongnu.org/projects/acl;
    description = "Library and tools for manipulating access control lists";
  };
}
