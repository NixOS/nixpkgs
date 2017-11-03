{ stdenv, fetchurl }:

let
  mkNixBackground = { name, src, description } @ attrs:

    stdenv.mkDerivation {
      inherit name src;

      unpackPhase = "true";

      installPhase = ''
        mkdir -p $out/share/artwork/gnome
        ln -s $src $out/share/artwork/gnome/${src.name}
      '';

      meta = with stdenv.lib; {
        inherit description;
        homepage = https://github.com/NixOS/nixos-artwork;
        license = licenses.free;
        platforms = platforms.all;
      };
    };

in

{

  gnome-dark = mkNixBackground {
    name = "gnome-dark-2015-02-27";
    description = "Gnome Dark background for Nix";
    src = fetchurl {
      url = https://raw.githubusercontent.com/NixOS/nixos-artwork/7ece5356398db14b5513392be4b31f8aedbb85a2/gnome/Gnome_Dark.png;
      sha256 = "0c7sl9k4zdjwvdz3nhlm8i4qv4cjr0qagalaa1a438jigixx27l7";
    };
  };

  mosaic-blue = mkNixBackground {
    name = "mosaic-blue-2016-02-19";
    description = "Mosaic blue background for Nix";
    src = fetchurl {
      url = https://raw.githubusercontent.com/NixOS/nixos-artwork/766f10e0c93cb1236a85925a089d861b52ed2905/wallpapers/nix-wallpaper-mosaic-blue.png;
      sha256 = "1cbcssa8qi0giza0k240w5yy4yb2bhc1p1r7pw8qmziprcmwv5n5";
    };
  };

  simple-blue = mkNixBackground {
    name = "simple-blue-2016-02-19";
    description = "Simple blue background for Nix";
    src = fetchurl {
      url = https://raw.githubusercontent.com/NixOS/nixos-artwork/766f10e0c93cb1236a85925a089d861b52ed2905/wallpapers/nix-wallpaper-simple-blue.png;
      sha256 = "1llr175m454aqixxwbp3kb5qml2hi1kn7ia6lm7829ny6y7xrnms";
    };
  };

  simple-dark-gray = mkNixBackground {
    name = "simple-dark-gray-2016-02-19";
    description = "Simple dark gray background for Nix";
    src = fetchurl {
      url = https://raw.githubusercontent.com/NixOS/nixos-artwork/766f10e0c93cb1236a85925a089d861b52ed2905/wallpapers/nix-wallpaper-simple-dark-gray.png;
      sha256 = "1282cnqc5qynp0q9gdll7bgpw23yp5bhvaqpar59ibkh3iscg8i5";
    };
  };

  simple-light-gray = mkNixBackground {
    name = "simple-light-gray-2016-02-19";
    description = "Simple light gray background for Nix";
    src = fetchurl {
      url = https://raw.githubusercontent.com/NixOS/nixos-artwork/766f10e0c93cb1236a85925a089d861b52ed2905/wallpapers/nix-wallpaper-simple-light-gray.png;
      sha256 = "0i6d0xv1nzrv7na9hjrgzl3jrwn81vnprnq2pxyznlxbjcgkjnk2";
    };
  };

  simple-red = mkNixBackground {
    name = "simple-red-2016-02-19";
    description = "Simple red background for Nix";
    src = fetchurl {
      url = https://raw.githubusercontent.com/NixOS/nixos-artwork/766f10e0c93cb1236a85925a089d861b52ed2905/wallpapers/nix-wallpaper-simple-red.png;
      sha256 = "16drprsi3q8xbxx3bxp54yld04c4lq6jankw8ww1irg7z61a6wjs";
    };
  };

  stripes-logo = mkNixBackground {
    name = "stripes-logo-2016-02-19";
    description = "Stripes logo background for Nix";
    src = fetchurl {
      url = https://raw.githubusercontent.com/NixOS/nixos-artwork/766f10e0c93cb1236a85925a089d861b52ed2905/wallpapers/nix-wallpaper-stripes-logo.png;
      sha256 = "0cqjkgp30428c1yy8s4418k4qz0ycr6fzcg4rdi41wkh5g1hzjnl";
    };
  };

  stripes = mkNixBackground {
    name = "stripes-2016-02-19";
    description = "Stripes background for Nix";
    src = fetchurl {
      url = https://raw.githubusercontent.com/NixOS/nixos-artwork/766f10e0c93cb1236a85925a089d861b52ed2905/wallpapers/nix-wallpaper-stripes.png;
      sha256 = "116337wv81xfg0g0bsylzzq2b7nbj6hjyh795jfc9mvzarnalwd3";
    };
  };

}
