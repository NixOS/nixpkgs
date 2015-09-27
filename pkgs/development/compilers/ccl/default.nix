{ stdenv, fetchsvn, gcc, glibc, m4, coreutils }:

/* TODO: there are also MacOS, FreeBSD and Windows versions */
assert stdenv.system == "x86_64-linux" || stdenv.system == "i686-linux"
  || stdenv.system == "armv7l-linux" || stdenv.system == "armv6l-linux";

let
  options = rec {
    x86_64-linux = {
      arch = "linuxx86";
      sha256 = "04p77n18cw0bc8i66mp2vfrhlliahrx66lm004a3nw3h0mdk0gd8";
      runtime = "lx86cl64";
      kernel = "linuxx8664";
    };
    i686-linux = {
      arch = "linuxx86";
      sha256 = x86_64-linux.sha256;
      runtime = "lx86cl";
      kernel = "linuxx8632";
    };
    armv7l-linux = {
      arch = "linuxarm";
      sha256 = "0xg9p1q1fpgyfhwjk2hh24vqzddzx5zqff04lycf0vml5qw1gnkv";
      runtime = "armcl";
      kernel = "linuxarm";
    };
    armv6l-linux = armv7l-linux;
  };
  cfg = options.${stdenv.system};
in
stdenv.mkDerivation rec {
  name     = "ccl-${version}";
  version  = "1.10";
  revision = "16313";

  src = fetchsvn {
    url = "http://svn.clozure.com/publicsvn/openmcl/release/${version}/${cfg.arch}/ccl";
    rev = revision;
    sha256 = cfg.sha256;
  };

  buildInputs = [ gcc glibc m4 ];

  CCL_RUNTIME = cfg.runtime;
  CCL_KERNEL = cfg.kernel;

  patchPhase = ''
    substituteInPlace lisp-kernel/${CCL_KERNEL}/Makefile \
      --replace "svnversion" "echo ${revision}" \
      --replace "/bin/rm"    "${coreutils}/bin/rm" \
      --replace "/bin/echo"  "${coreutils}/bin/echo"

    substituteInPlace lisp-kernel/m4macros.m4 \
      --replace "/bin/pwd" "${coreutils}/bin/pwd"
  '';

  buildPhase = ''
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
