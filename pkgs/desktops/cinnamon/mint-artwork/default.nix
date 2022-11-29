{ stdenv
, lib
, fetchurl
, glib
, nixos-artwork
}:

stdenv.mkDerivation rec {
  pname = "mint-artwork";
  version = "1.6.8";

  src = fetchurl {
    urls = [
      "http://packages.linuxmint.com/pool/main/m/mint-artwork/mint-artwork_${version}.tar.xz"
      "https://web.archive.org/web/20221129013553/http://packages.linuxmint.com/pool/main/m/mint-artwork/mint-artwork_${version}.tar.xz"
    ];
    hash = "sha256-HPnb5Mb6tvzREZbW9SyDNQ6ST6RPmOUVdA9MW8oyRAM=";
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
      -e s,linuxmint-logo-ring-symbolic,cinnamon-symbolic,g \
      {} +

    # fixup broken symlink
    ln -sf ./sele_ring.jpg usr/share/backgrounds/linuxmint/default_background.jpg

    mv etc $out/etc
    mv usr/share $out/share
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/mint-artwork";
    description = "Artwork for the cinnamon desktop";
    license = licenses.gpl3; # from debian/copyright
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
