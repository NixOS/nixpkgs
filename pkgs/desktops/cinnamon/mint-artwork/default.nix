{ stdenv
, fetchurl
, glib
, nixos-artwork
}:

stdenv.mkDerivation rec {
  pname = "mint-artwork";
  version = "1.4.3";

  src = fetchurl {
    url = "http://packages.linuxmint.com/pool/main/m/mint-artwork/mint-artwork_${version}.tar.xz";
    sha256 = "126asxpg722qfg2wkwcr7bhsplchq3jn6bkdwf1scpc5za8dd62j";
  };

  nativeBuildInputs = [
    glib
  ];

  installPhase = ''
    mkdir $out

    # note: we fuck up a bunch of stuff but idc
    find . -type f -exec sed -i \
      -e s,/usr/share/backgrounds/linuxmint/default_background.jpg,${nixos-artwork.wallpapers.simple-dark-gray}/share/artwork/gnome/nix-wallpaper-simple-dark-gray.png,g \
      -e s,/usr/share,$out/share,g \
      -e s,DMZ-White,Vanilla-DMZ,g \
      -e s,DMZ-Black,Vanilla-DMZ-AA,g \
      -e s,linuxmint-logo-5,cinnamon-symbolic,g \
      -e s,^theme-name=Mint-X$,theme-name=Mint-X-Dark,g \
      {} +

    # fixup broken symlink
    ln -sf ./sele_ring.jpg usr/share/backgrounds/linuxmint/default_background.jpg

    mv etc $out/etc
    mv usr/share $out/share
  '';
}
