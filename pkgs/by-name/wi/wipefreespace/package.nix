{
  stdenv,
  lib,
  fetchurl,
  e2fsprogs,
  ntfs3g,
  xfsprogs,
  reiser4progs,
  libaal,
  jfsutils,
  libuuid,
  texinfo,
}:

stdenv.mkDerivation rec {
  pname = "wipefreespace";
  version = "2.6";

  src = fetchurl {
    url = "mirror://sourceforge/project/wipefreespace/wipefreespace/${version}/wipefreespace-${version}.tar.gz";
    hash = "sha256-Pt6MDQ9wSJbL4tW/qckTpFsvE9FdXIkp/QmnYSlWR/M=";
  };

  nativeBuildInputs = [
    texinfo
  ];

  # missed: Reiser3 FAT12/16/32 MinixFS HFS+ OCFS
  buildInputs = [
    e2fsprogs
    ntfs3g
    xfsprogs
    reiser4progs
    libaal
    jfsutils
    libuuid
  ];

  strictDeps = true;

  preConfigure = ''
    export PATH=$PATH:${xfsprogs}/bin
    export CFLAGS=-I${jfsutils}/include
    export LDFLAGS="-L${jfsutils}/lib -L${reiser4progs}/lib"
  '';

  meta = with lib; {
    description = "Program which will securely wipe the free space";
    homepage = "https://wipefreespace.sourceforge.io";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ catap ];
    mainProgram = "wipefreespace";
  };
}
