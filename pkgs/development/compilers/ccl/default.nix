{ stdenv, fetchsvn, gcc, glibc, m4 }:

/* TODO: there are also MacOS, FreeBSD and Windows versions */
assert stdenv.system == "x86_64-linux" || stdenv.system == "i686-linux";

stdenv.mkDerivation rec {
  name     = "ccl-${version}";
  version  = "1.10";
  revision = "16313";

  src = fetchsvn {
    url = http://svn.clozure.com/publicsvn/openmcl/release/1.10/linuxx86/ccl;
    rev = revision;
    sha256 = "11lmdvzj1mbm7mbr22vjbcrsvinyz8n32a91ms324xqdqpr82ifb";
  };

  buildInputs = [ gcc glibc m4 ];

  CCL_RUNTIME = if stdenv.system == "x86_64-linux" then "lx86cl64"   else "lx86cl";
  CCL_KERNEL  = if stdenv.system == "x86_64-linux" then "linuxx8664" else "linuxx8632";

  buildPhase = ''
    sed -i lisp-kernel/${CCL_KERNEL}/Makefile -e's/svnversion/echo ${revision}/g'

    make -C lisp-kernel/${CCL_KERNEL} clean
    make -C lisp-kernel/${CCL_KERNEL} all

    ./${CCL_RUNTIME} -n -b -e '(ccl:rebuild-ccl :full t)' -e '(ccl:quit)'
  '';

  installPhase = ''
    mkdir -p "$out/share"
    cp -r .  "$out/share/ccl-installation"

    mkdir -p "$out/bin"
    echo -e '#!/bin/sh\n'"$out/share/ccl-installation/${CCL_RUNTIME}"' "$@"\n' > "$out"/bin/"${CCL_RUNTIME}"
    chmod a+x "$out"/bin/"${CCL_RUNTIME}"
  '';

  meta = {
    description = "Clozure Common Lisp";
    homepage    = http://ccl.clozure.com/;
    maintainers = with stdenv.lib.maintainers; [ raskin muflax ];
    platforms   = stdenv.lib.platforms.linux;
    license     = stdenv.lib.licenses.lgpl21;
  };
}
