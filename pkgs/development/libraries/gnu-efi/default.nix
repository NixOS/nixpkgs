{ stdenv
, fetchurl
}:

let version = "3.0s"; in stdenv.mkDerivation {

  name = "gnu-efi-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/gnu-efi/gnu-efi_${version}.orig.tar.gz";
    sha256 = "18bpswzkj81dadq1b7n2s9g0cz60l34ggzxlq21mb8va10j9zmhh";
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
