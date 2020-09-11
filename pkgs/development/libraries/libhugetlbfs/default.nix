{ stdenv, lib, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "libhugetlbfs";
  version = "2.22";

  src = fetchurl {
    url = "https://github.com/libhugetlbfs/libhugetlbfs/releases/download/${version}/libhugetlbfs-${version}.tar.gz";
    sha256 = "11b7k8xvgx68rjzidm12a6l6b23hwi7hj149y9xxfz2j5kmakp4l";
  };

  outputs = [ "bin" "dev" "man" "doc" "lib" "out" ];

  patches = [
    # Don't check that 32-bit and 64-bit libraries don't get installed
    # to the same place if only one platform is being built for.
    # Can be removed if build succeeds without it.
    (fetchpatch {
      url = "https://groups.google.com/forum/message/raw?msg=libhugetlbfs/IswjDAygfwA/PKy7MZbVAAAJ";
      sha256 = "00fyrhn380d6swil8pcf4x0krl1113ghswrvjn3m9czc3h4p385a";
    })
  ];

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
  ] ++ map (n: "MANDIR${n}=$(man)/share/man/man${n}")
    (lib.genList (n: toString (n + 1)) 8);

  # Default target builds tests as well, and the tests want a static
  # libc.
  buildFlags = [ "libs" "tools" ];
  installTargets = [ "install" "install-docs" ];

  meta = with lib; {
    description = "library and utilities for Linux hugepages";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
