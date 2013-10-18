{ stdenv
, fetchurl
}:

let version = "3.0u"; in stdenv.mkDerivation {

  name = "gnu-efi-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/gnu-efi/gnu-efi_${version}.orig.tar.gz";
    sha256 = "0klkdxh1aqwwfm393q67nxww6liffyp2lfybbnh4q819b06la39w";
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
    make PREFIX="$out" install
    mkdir -pv $out/share/gnu-efi
    install -D -m644 apps/*.efi $out/share/gnu-efi
  '';
}
