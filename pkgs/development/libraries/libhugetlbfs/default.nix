{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libhugetlbfs";
  version = "2.23";

  src = fetchurl {
    url = "https://github.com/libhugetlbfs/libhugetlbfs/releases/download/${version}/libhugetlbfs-${version}.tar.gz";
    sha256 = "0ya4q001g111d3pqlzrf3yaifadl0ccirx5dndz1pih7x3qp41mp";
  };

  outputs = [ "bin" "dev" "man" "doc" "lib" "out" ];

  postConfigure = ''
    patchShebangs ld.hugetlbfs
  '';

  enableParallelBuilding = true;
  makeFlags = [
    "BUILDTYPE=NATIVEONLY"
    "PREFIX=$(out)"
    "HEADERDIR=$(dev)/include"
    "LIBDIR32=$(lib)/$(LIB32)"
    "LIBDIR64=$(lib)/$(LIB64)"
    "EXEDIR=$(bin)/bin"
    "DOCDIR=$(doc)/share/doc/libhugetlbfs"
    "MANDIR=$(man)/share/man"
  ];

  # Default target builds tests as well, and the tests want a static
  # libc.
  buildFlags = [ "libs" "tools" ];
  installTargets = [ "install" "install-docs" ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "library and utilities for Linux hugepages";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
