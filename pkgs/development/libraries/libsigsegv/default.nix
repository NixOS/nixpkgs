{ stdenv, fetchurl
, buildPlatform, hostPlatform
}:

stdenv.mkDerivation rec {
  name = "libsigsegv-2.11";

  src = fetchurl {
    url = "mirror://gnu/libsigsegv/${name}.tar.gz";
    sha256 = "063swdvq7mbmc1clv0rnh20grwln1zfc2qnm0sa1hivcxyr2wz6x";
  };

  doCheck = hostPlatform == buildPlatform;

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
