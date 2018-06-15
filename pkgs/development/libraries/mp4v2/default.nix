{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "mp4v2-2.0.0";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/mp4v2/${name}.tar.bz2";
    sha256 = "0f438bimimsvxjbdp4vsr8hjw2nwggmhaxgcw07g2z361fkbj683";
  };

  patches = [
    (fetchurl {
      name = "gcc-7.patch";
      url = "https://src.fedoraproject.org/cgit/rpms/libmp4v2.git/plain/"
          + "0004-Fix-GCC7-build.patch?id=d7aeedabb";
      sha256 = "0sbn0il7lmk77yrjyb4f0a3z3h8gsmdkscvz5n9hmrrrhrwf672w";
    })
  ];

  # `faac' expects `mp4.h'.
  postInstall = "ln -s mp4v2/mp4v2.h $out/include/mp4.h";

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  meta = {
    homepage = https://code.google.com/archive/p/mp4v2/;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mpl11;
  };
}
