{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "libsigsegv-2.8";

  src = fetchurl {
    url = "mirror://gnu/libsigsegv/${name}.tar.gz";
    sha256 = "052vcxgajdlvc77dqcs48axjz698r1g2gyagz2qcr6zvkyw304w6";
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
