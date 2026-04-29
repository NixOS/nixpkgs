{
  fetchpatch,
  fetchzip,
  lib,
  stdenv,

  autoconf,
  automake116x,
  cddlib,
  gmpxx,
  libtool,

  programPrefix ? "topcom-",
}:
let
  version = "1.1.2";
  versionUrl = builtins.replaceStrings [ "." "c" ] [ "_" "_gamma" ] "${version}";
in
stdenv.mkDerivation {
  pname = "topcom";
  version = version;

  src = fetchzip {
    url = "https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM-Downloads/TOPCOM-${versionUrl}.tgz";
    hash = "sha256-r6dA2rQzxMu0Xxq5yl9rBZ5MJTRnmWVLav/F/QpkZ1A=";
  };

  buildInputs = [
    cddlib
    gmpxx
  ];

  nativeBuildInputs = [
    autoconf
    automake116x
    libtool
  ];

  __structuredAttrs = true;

  strictDeps = true;

  patches = [
    (fetchpatch {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/topcom/-/raw/main/system-libs.patch";
      sha256 = "sha256-F+1ZtluGL3i+LKWp0poQnx2ZlV5TSp6WSK5yl2FmOP4";
    })
  ];

  postPatch = ''
    substituteInPlace lib-src/Makefile.am lib-src-reg/Makefile.am src/Makefile.am src-reg/Makefile.am \
      --replace-warn '$(includedir)/cddlib' '${cddlib}/include/cddlib'
  '';

  preConfigure = "autoconf";

  configureFlags = [
    "--program-prefix=${programPrefix}"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Package for computing Triangulations Of Point Configurations and Oriented Matroid";
    longDescription = ''
      TOPCOM is a package for computing Triangulations Of Point Configurations
      and Oriented Matroids. It was very much inspired by the maple program
      PUNTOS, which was written by Jesus de Loera. TOPCOM is entirely written
      in C++, so there is a significant speed up compared to PUNTOS.
    '';
    homepage = "https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM/index.html";
    license = lib.licenses.gpl3Plus;
  };
}
