{ lib, stdenv, fetchurl }:

let
  mkNixBackground = { name, src, description }:

  let
    pkg = stdenv.mkDerivation {
      inherit name src;

      dontUnpack = true;

      installPhase = ''
        # GNOME
        mkdir -p $out/share/backgrounds/nixos
        ln -s $src $out/share/backgrounds/nixos/${src.name}

        # TODO: is this path still needed?
        mkdir -p $out/share/artwork/gnome
        ln -s $src $out/share/artwork/gnome/${src.name}

        # KDE
        mkdir -p $out/share/wallpapers/${name}/contents/images
        ln -s $src $out/share/wallpapers/${name}/contents/images/${src.name}
        cat >>$out/share/wallpapers/${name}/metadata.desktop <<_EOF
[Desktop Entry]
Name=${name}
X-KDE-PluginInfo-Name=${name}
_EOF
      '';

      passthru = {
        gnomeFilePath = "${pkg}/share/backgrounds/nixos/${src.name}";
        kdeFilePath = "${pkg}/share/wallpapers/${name}/contents/images/${src.name}";
      };

      meta = with lib; {
        inherit description;
        homepage = "https://github.com/NixOS/nixos-artwork";
        license = licenses.free;
        platforms = platforms.all;
      };
    };
in pkg;

in

rec {

  dracula = mkNixBackground {
    name = "dracula-2020-07-02";
    description = "Nix background based on the Dracula color palette";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/03c6c20be96c38827037d2238357f2c777ec4aa5/wallpapers/nix-wallpaper-dracula.png";
      sha256 = "07ly21bhs6cgfl7pv4xlqzdqm44h22frwfhdqyd4gkn2jla1waab";
    };
  };

  gnome-dark = simple-dark-gray-bottom;

  mosaic-blue = mkNixBackground {
    name = "mosaic-blue-2016-02-19";
    description = "Mosaic blue background for Nix";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/766f10e0c93cb1236a85925a089d861b52ed2905/wallpapers/nix-wallpaper-mosaic-blue.png";
      sha256 = "1cbcssa8qi0giza0k240w5yy4yb2bhc1p1r7pw8qmziprcmwv5n5";
    };
  };

  nineish = mkNixBackground {
    name = "nineish-2019-12-04";
    description = "Nix background inspired by simpler times";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/da01f68d21ddfdc9f1c6e520c2170871c81f1cf5/wallpapers/nix-wallpaper-nineish.png";
      sha256 = "1mwvnmflp0z1biyyhfz7mjn7i1nna94n7jyns3na2shbfkaq7i0h";
    };
  };

  nineish-dark-gray = mkNixBackground {
    name = "nineish-dark-gray-2020-07-02";
    description = "Dark gray Nix background inspired by simpler times";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/f07707cecfd89bc1459d5dad76a3a4c5315efba1/wallpapers/nix-wallpaper-nineish-dark-gray.png";
      sha256 = "07zl1dlxqh9dav9pibnhr2x1llywwnyphmzcdqaby7dz5js184ly";
    };
  };

  simple-blue = mkNixBackground {
    name = "simple-blue-2016-02-19";
    description = "Simple blue background for Nix";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/766f10e0c93cb1236a85925a089d861b52ed2905/wallpapers/nix-wallpaper-simple-blue.png";
      sha256 = "1llr175m454aqixxwbp3kb5qml2hi1kn7ia6lm7829ny6y7xrnms";
    };
  };

  simple-dark-gray = mkNixBackground {
    name = "simple-dark-gray-2016-02-19";
    description = "Simple dark gray background for Nix";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/766f10e0c93cb1236a85925a089d861b52ed2905/wallpapers/nix-wallpaper-simple-dark-gray.png";
      sha256 = "1282cnqc5qynp0q9gdll7bgpw23yp5bhvaqpar59ibkh3iscg8i5";
    };
  };

  simple-dark-gray-bootloader = mkNixBackground {
    name = "simple-dark-gray-bootloader-2018-08-28";
    description = "Simple dark gray background for NixOS, specifically bootloaders.";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/9d1f11f652ed5ffe460b6c602fbfe2e7e9a08dff/bootloader/nix-wallpaper-simple-dark-gray_bootloader.png";
      sha256 = "0v26kfydn7alr81f2qpgsqdiq2zk7yrwlgibx2j7k91z9h47dpj9";
    };
  };

  simple-dark-gray-bottom = mkNixBackground {
    name = "simple-dark-gray-2018-08-28";
    description = "Simple dark gray background for NixOS, specifically bootloaders and graphical login.";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/783c38b22de09f6ee33aacc817470a4513392d83/wallpapers/nix-wallpaper-simple-dark-gray_bottom.png";
      sha256 = "13hi4jwp5ga06dpdw5l03b4znwn58fdjlkqjkg824isqsxzv6k15";
    };
  };

  simple-light-gray = mkNixBackground {
    name = "simple-light-gray-2016-02-19";
    description = "Simple light gray background for Nix";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/766f10e0c93cb1236a85925a089d861b52ed2905/wallpapers/nix-wallpaper-simple-light-gray.png";
      sha256 = "0i6d0xv1nzrv7na9hjrgzl3jrwn81vnprnq2pxyznlxbjcgkjnk2";
    };
  };

  simple-red = mkNixBackground {
    name = "simple-red-2016-02-19";
    description = "Simple red background for Nix";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/766f10e0c93cb1236a85925a089d861b52ed2905/wallpapers/nix-wallpaper-simple-red.png";
      sha256 = "16drprsi3q8xbxx3bxp54yld04c4lq6jankw8ww1irg7z61a6wjs";
    };
  };

  stripes-logo = mkNixBackground {
    name = "stripes-logo-2016-02-19";
    description = "Stripes logo background for Nix";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/766f10e0c93cb1236a85925a089d861b52ed2905/wallpapers/nix-wallpaper-stripes-logo.png";
      sha256 = "0cqjkgp30428c1yy8s4418k4qz0ycr6fzcg4rdi41wkh5g1hzjnl";
    };
  };

  stripes = mkNixBackground {
    name = "stripes-2016-02-19";
    description = "Stripes background for Nix";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/766f10e0c93cb1236a85925a089d861b52ed2905/wallpapers/nix-wallpaper-stripes.png";
      sha256 = "116337wv81xfg0g0bsylzzq2b7nbj6hjyh795jfc9mvzarnalwd3";
    };
  };

}
