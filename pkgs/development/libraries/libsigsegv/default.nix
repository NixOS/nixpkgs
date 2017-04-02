{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "libsigsegv-2.10";

  src = fetchurl {
    url = "mirror://gnu/libsigsegv/${name}.tar.gz";
    sha256 = "16hrs8k3nmc7a8jam5j1fpspd6sdpkamskvsdpcw6m29vnis8q44";
  };

  # Based on https://github.com/davidgfnet/buildroot-Os/blob/69fe6065b9dd1cb4dcc0a4b554e42cc2e5bd0d60/package/libsigsegv/libsigsegv-0002-fix-aarch64-build.patch
  # but applied directly to configure since we can't use autoreconf while bootstrapping.
  patches = if stdenv.isAarch64 || stdenv.cross.arch or "" == "aarch64"
    then [ ./aarch64.patch ]
    else null; # TODO: change to lib.optional on next mass rebuild

  # https://github.com/NixOS/nixpkgs/issues/6028
  doCheck = false;

  meta = {
    homepage = http://www.gnu.org/software/libsigsegv/;
    description = "Library to handle page faults in user mode";

    longDescription = ''
      GNU libsigsegv is a library for handling page faults in user mode. A
      page fault occurs when a program tries to access to a region of memory
      that is currently not available. Catching and handling a page fault is
      a useful technique for implementing pageable virtual memory,
      memory-mapped access to persistent databases, generational garbage
      collectors, stack overflow handlers, distributed shared memory, and
      more.
    '';

    license = stdenv.lib.licenses.gpl2Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.unix;
  };
}
