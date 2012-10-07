{ stdenv
, fetchurl
}:

stdenv.mkDerivation {
  name = "gnu-efi-3.0r";

  src = fetchurl {
    url = "mirror://sourceforge/gnu-efi/gnu-efi_3.0r.orig.tar.gz";
    sha256 = "1zi298wsg8v29xj4azcawqfjbxqi2w7l60agf7x2ph2lnqlga2v5";
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
