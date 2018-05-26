{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libnfnetlink-1.0.1";

  src = fetchurl {
    url = "http://www.netfilter.org/projects/libnfnetlink/files/${name}.tar.bz2";
    sha256 = "06mm2x4b01k3m7wnrxblk9j0mybyr4pfz28ml7944xhjx6fy2w7j";
  };

  patches = [
    ./Use-stdlib-uint-instead-of-u_int.patch
  ];

  meta = {
    description = "Low-level library for netfilter related kernel/userspace communication";
    longDescription = ''
      libnfnetlink is the low-level library for netfilter related kernel/userspace communication.
      It provides a generic messaging infrastructure for in-kernel netfilter subsystems
      (such as nfnetlink_log, nfnetlink_queue, nfnetlink_conntrack) and their respective users
      and/or management tools in userspace.

      This library is not meant as a public API for application developers.
      It is only used by other netfilter.org projects, like the aforementioned ones.
    '';
    homepage = http://www.netfilter.org/projects/libnfnetlink/index.html;
    license = stdenv.lib.licenses.gpl2;

    platforms = stdenv.lib.platforms.linux;
  };
}
