{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libhugetlbfs";
  version = "2.23";

  src = fetchurl {
    url = "https://github.com/libhugetlbfs/libhugetlbfs/releases/download/${version}/libhugetlbfs-${version}.tar.gz";
    sha256 = "0ya4q001g111d3pqlzrf3yaifadl0ccirx5dndz1pih7x3qp41mp";
  };

  patches = [
    (fetchurl {
      url = "https://build.opensuse.org/public/source/openSUSE:Factory/libhugetlbfs/glibc-2.34-fix.patch?rev=50";
      sha256 = "sha256-eRQa6M0ZdHMtwA5nnzDTWYv/x4AnRZhj+MpDiwyCvVM=";
    })
  ];

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
  ] ++ lib.optionals (stdenv.buildPlatform.system != stdenv.hostPlatform.system) [
    # The ARCH logic defaults to querying `uname`, which will return build platform arch
    "ARCH=${stdenv.hostPlatform.uname.processor}"
  ];

  # Default target builds tests as well, and the tests want a static
  # libc.
  buildFlags = [ "libs" "tools" ];
  installTargets = [ "install" "install-docs" ];

  meta = with lib; {
    description = "library and utilities for Linux hugepages";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    badPlatforms = flatten [
      systems.inspect.platformPatterns.isStatic
      systems.inspect.patterns.isMusl
    ];
  };
}
