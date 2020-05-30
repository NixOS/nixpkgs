{ stdenv, fetchurl, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "nordic";
  version = "1.9.0";

  srcs = [
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic/releases/download/v${version}/Nordic.tar.xz";
      sha256 = "12x13h9w4yqk56a009zpj1kq3vn2hn290xryfv1b0vyf2r45rsn7";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic/releases/download/v${version}/Nordic-standard-buttons.tar.xz";
      sha256 = "0f38nx1rvp9l6xz62yx6cbab4im8d425gxr52jkc8gfqpl5lrf0q";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic/releases/download/v${version}/Nordic-darker.tar.xz";
      sha256 = "0frp0jf7hbiapl3m67av7rbm3sx8db52zi3j01k2hysh6kba7x33";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic/releases/download/v${version}/Nordic-darker-standard-buttons.tar.xz";
      sha256 = "0grfsjr9kq0lszmqxvjvpgvf4avm34446nqykz1zfpdg50j7r54b";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic/releases/download/v${version}/Nordic-bluish-accent.tar.xz";
      sha256 = "0zndldwavir22ay2r0jazpikzzww3hc09gsmbiyjmw54v29qhl9r";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic/releases/download/v${version}/Nordic-bluish-accent-standard-buttons.tar.xz";
      sha256 = "1b9d2fvdndyh7lh3xhmc75csfbapl4gv59y7wy15k2awisvlvz07";
    })
  ];

  sourceRoot = ".";

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    mkdir -p $out/share/themes
    cp -a Nordic* $out/share/themes
    rm $out/share/themes/*/{LICENSE,README.md}
  '';

  meta = with stdenv.lib; {
    description = "Dark Gtk theme created using the awesome Nord color pallete";
    homepage = "https://github.com/EliverLara/Nordic";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
