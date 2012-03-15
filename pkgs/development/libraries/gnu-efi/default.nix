{ stdenv
, fetchurl
}:

stdenv.mkDerivation {
  name = "gnu-efi-3.0p";

  src = fetchurl {
    url = "mirror://sourceforge/gnu-efi/gnu-efi_3.0p.orig.tar.gz";
    sha256 = "1pm4wk1gma7mb8z19js7kb5y31a0zk308mkafmq6gb0b2a0i39cn";
  };

  meta = {
    description = "GNU EFI development toolchain";
    homepage = http://sourceforge.net/projects/gnu-efi/;
    license = "GPL";
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms = ["x86_64-linux" "i686-linux"];
  };

  buildFlags = [
    "CC=cc"
    "AS=as"
    "LD=ld"
    "AR=ar"
    "RANLIB=ranlib"
    "OBJCOPY=objcopy"
  ];

  buildPhase = ''
    make $buildFlags
    make $buildFlags -C apps clean all
  '';

  installPhase = ''
    make INSTALLROOT="$out" install
    mkdir -pv $out/share/gnu-efi
    install -D -m644 apps/*.efi $out/share/gnu-efi
  '';
}
