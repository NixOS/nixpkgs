{
  lib,
  stdenv,
  fetchurl,
  installShellFiles,
  e2fsprogs,
}:

let
  manpage = fetchurl {
    url = "https://manpages.ubuntu.com/manpages.gz/xenial/man8/zerofree.8.gz";
    sha256 = "0y132xmjl02vw41k794psa4nmjpdyky9f6sf0h4f7rvf83z3zy4k";
  };
in
stdenv.mkDerivation rec {
  pname = "zerofree";
  version = "1.1.1";

  src = fetchurl {
    url = "https://frippery.org/uml/${pname}-${version}.tgz";
    sha256 = "0rrqfa5z103ws89vi8kfvbks1cfs74ix6n1wb6vs582vnmhwhswm";
  };

  buildInputs = [
    e2fsprogs
    installShellFiles
  ];

  installPhase = ''
    mkdir -p $out/bin $out/share/zerofree
    cp zerofree $out/bin
    cp COPYING $out/share/zerofree/COPYING
    installManPage ${manpage}
  '';

  meta = {
    homepage = "https://frippery.org/uml/";
    description = "Zero free blocks from ext2, ext3 and ext4 file-systems";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.theuni ];
    mainProgram = "zerofree";
  };
}
