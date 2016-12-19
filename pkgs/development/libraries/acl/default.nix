{ stdenv, fetchurl, gettext, attr }:

stdenv.mkDerivation rec {
  name = "acl-2.2.52";

  src = fetchurl {
    url = "mirror://savannah/acl/${name}.src.tar.gz";
    sha256 = "08qd9s3wfhv0ajswsylnfwr5h0d7j9d4rgip855nrh400nxp940p";
  };

  outputs = [ "bin" "dev" "out" "doc" ];

  nativeBuildInputs = [ gettext ];
  buildInputs = [ attr ];

  # Upstream use C++-style comments in C code. Remove them.
  # This comment breaks compilation if too strict gcc flags are used.
  patchPhase = ''
    echo "Removing C++-style comments from include/acl.h"
    sed -e '/^\/\//d' -i include/acl.h
  '';

  configureFlags = "MAKE=make MSGFMT=msgfmt MSGMERGE=msgmerge XGETTEXT=xgettext ZIP=gzip ECHO=echo SED=sed AWK=gawk";

  installTargets = "install install-lib install-dev";

  meta = {
    homepage = http://savannah.nongnu.org/projects/acl;
    description = "Library and tools for manipulating access control lists";
    platforms = stdenv.lib.platforms.linux;
  };
}
