{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "libsigsegv-2.7";

  src = fetchurl {
    url = "mirror://gnu/libsigsegv/${name}.tar.gz";
    sha256 = "1j21wanj8wsrvgjb8hjvydl5la70fd1qi21yfm6xmgmwbw26973h";
  };

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/libsigsegv/;
    description = "GNU libsigsegv, a library to handle page faults in user mode";

    longDescription = ''
      GNU libsigsegv is a library for handling page faults in user mode. A
      page fault occurs when a program tries to access to a region of memory
      that is currently not available. Catching and handling a page fault is
      a useful technique for implementing pageable virtual memory,
      memory-mapped access to persistent databases, generational garbage
      collectors, stack overflow handlers, distributed shared memory, and
      more.
    '';

    license = "GPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
