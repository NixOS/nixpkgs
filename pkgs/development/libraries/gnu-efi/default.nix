{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "gnu-efi_${version}";
  version = "3.0v";

  src = fetchurl {
    url = "mirror://sourceforge/gnu-efi/${name}.orig.tar.gz";
    sha256 = "1pqgpm999l7zb8gh3s0zd2ax6f0n2l4jip7h0d2y91hhcy6zjxn7";
  };

  arch = with stdenv.lib; head (splitString "-" stdenv.system);

  makeFlags = [
    "CC=gcc"
    "AS=as"
    "LD=ld"
    "AR=ar"
    "RANLIB=ranlib"
    "OBJCOPY=objcopy"
  ];

  buildPhase = ''
    make $makeFlags
    make $makeFlags -C apps clean all
  '';

  installPhase = ''
    mkdir -pv $out/include/efi/{protocol,$arch}
    make PREFIX="$out" $makeFlags install
    mkdir -pv $out/share/gnu-efi
    install -D -m644 apps/*.efi $out/share/gnu-efi
  '';

  meta = with stdenv.lib; {
    description = "GNU EFI development toolchain";
    homepage = http://sourceforge.net/projects/gnu-efi/;
    license = licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms = platforms.linux;
  };
}
