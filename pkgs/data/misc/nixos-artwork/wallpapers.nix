{
  lib,
  stdenv,
  fetchurl,
}:

let
  mkNixBackground =
    {
      name,
      src,
      description,
      license ? lib.licenses.free,
    }:

    let
      pkg = stdenv.mkDerivation {
        inherit name src;

        dontUnpack = true;

        installPhase = ''
                  runHook preInstall

                  # GNOME
                  mkdir -p $out/share/backgrounds/nixos
                  ln -s $src $out/share/backgrounds/nixos/${src.name}

                  mkdir -p $out/share/gnome-background-properties/
                  cat <<EOF > $out/share/gnome-background-properties/${name}.xml
          <?xml version="1.0" encoding="UTF-8"?>
          <!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
          <wallpapers>
            <wallpaper deleted="false">
              <name>${name}</name>
              <filename>${src}</filename>
              <options>zoom</options>
              <shade_type>solid</shade_type>
              <pcolor>#ffffff</pcolor>
              <scolor>#000000</scolor>
            </wallpaper>
          </wallpapers>
          EOF

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

                  runHook postInstall
        '';

        passthru = {
          gnomeFilePath = "${pkg}/share/backgrounds/nixos/${src.name}";
          kdeFilePath = "${pkg}/share/wallpapers/${name}/contents/images/${src.name}";
        };

        meta = with lib; {
          inherit description license;
          homepage = "https://github.com/NixOS/nixos-artwork";
          platforms = platforms.all;
        };
      };
    in
    pkg;

in

rec {

  binary-black = mkNixBackground {
    name = "binary-black-2024-02-15";
    description = "Black binary wallpaper for Nix";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/8957e93c95867faafec7f9988cedddd6837859fa/wallpapers/nix-wallpaper-binary-black.png";
      hash = "sha256-mhSh0wz2ntH/kri3PF5ZrFykjjdQLhmlIlDDGFQIYWw=";
    };
    license = lib.licenses.cc-by-sa-40;
  };

  binary-blue = mkNixBackground {
    name = "binary-blue-2024-02-15";
    description = "Blue binary wallpaper for Nix";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/8957e93c95867faafec7f9988cedddd6837859fa/wallpapers/nix-wallpaper-binary-blue.png";
      hash = "sha256-oVIRSgool/CsduGingDr0FuJJIkGtfQHXYn0JBI2eho=";
    };
    license = lib.licenses.cc-by-sa-40;
  };

  binary-red = mkNixBackground {
    name = "binary-red-2024-02-15";
    description = "Red binary wallpaper for Nix";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/8957e93c95867faafec7f9988cedddd6837859fa/wallpapers/nix-wallpaper-binary-red.png";
      hash = "sha256-18UvtroyuAnluJ3EoLJWJAwN8T83s/ImPtsr5QTqvAA=";
    };
    license = lib.licenses.cc-by-sa-40;
  };

  binary-white = mkNixBackground {
    name = "binary-white-2024-02-15";
    description = "White binary wallpaper for Nix";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/8957e93c95867faafec7f9988cedddd6837859fa/wallpapers/nix-wallpaper-binary-white.png";
      hash = "sha256-imj+OmuhTNxRtE54715wWQUA7pe1f32+q3qi2V37i8U=";
    };
    license = lib.licenses.cc-by-sa-40;
  };

  catppuccin-frappe = mkNixBackground {
    name = "catppuccin-frappe-2024-02-15";
    description = "Catppuccin Frappé colorscheme wallpaper for NixOS";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/97444e18b7fe97705e8caedd29ae05e62cb5d4b7/wallpapers/nixos-wallpaper-catppuccin-frappe.png";
      hash = "sha256-wtBffKK9rqSJo8+7Wo8OMruRlg091vdroyUZj5mDPfI=";
    };
    license = lib.licenses.cc-by-sa-40;
  };

  catppuccin-latte = mkNixBackground {
    name = "catppuccin-latte-2024-02-15";
    description = "Catppuccin Latte colorscheme wallpaper for NixOS";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/97444e18b7fe97705e8caedd29ae05e62cb5d4b7/wallpapers/nixos-wallpaper-catppuccin-latte.png";
      hash = "sha256-Y6WCwmHOLBStj1D9mcU2082y1fhAFHna01ajfUHxehk=";
    };
    license = lib.licenses.cc-by-sa-40;
  };

  catppuccin-macchiato = mkNixBackground {
    name = "catppuccin-macchiato-2024-02-15";
    description = "Catppuccin Macchiato colorscheme wallpaper for NixOS";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/97444e18b7fe97705e8caedd29ae05e62cb5d4b7/wallpapers/nixos-wallpaper-catppuccin-macchiato.png";
      hash = "sha256-SkXrLbHvBOItJ7+8vW+6iXV+2g0f8bUJf9KcCXYOZF0=";
    };
    license = lib.licenses.cc-by-sa-40;
  };

  catppuccin-mocha = mkNixBackground {
    name = "catppuccin-mocha-2024-02-15";
    description = "Catppuccin Mochacolorscheme wallpaper for NixOS";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/97444e18b7fe97705e8caedd29ae05e62cb5d4b7/wallpapers/nixos-wallpaper-catppuccin-mocha.png";
      hash = "sha256-fmKFYw2gYAYFjOv4lr8IkXPtZfE1+88yKQ4vjEcax1s=";
    };
    license = lib.licenses.cc-by-sa-40;
  };

  dracula = mkNixBackground {
    name = "dracula-2020-07-02";
    description = "Nix background based on the Dracula color palette";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/03c6c20be96c38827037d2238357f2c777ec4aa5/wallpapers/nix-wallpaper-dracula.png";
      hash = "sha256-SykeFJXCzkeaxw06np0QkJCK28e0k30PdY8ZDVcQnh4=";
    };
    license = lib.licenses.cc-by-sa-40;
  };

  gear = mkNixBackground {
    name = "gear-2022-04-19";
    description = "3D wallpaper for Nix";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/bcdd2770f5f4839fddc9b503e68db2bc3a87ca4d/wallpapers/nix-wallpaper-gear.png";
      hash = "sha256-2sT6b49/iClTs9QuUvpmZ5gcIeXI9kebs5IqgQN1RL8=";
    };
    license = lib.licenses.cc-by-sa-40;
  };

  gnome-dark = simple-dark-gray-bottom;

  gradient-grey = mkNixBackground {
    name = "gradient-grey-2018-10-20";
    description = "Simple grey gradient background for NixOS";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/3f7695afe75239720a32d6c38df7c9888b5ed581/wallpapers/NixOS-Gradient-grey.png";
      hash = "sha256-Tf4Xruf608hpl7YwL4Mq9l9egBOCN+W4KFKnqrgosLE=";
    };
    # license not clarified
  };

  moonscape = mkNixBackground {
    name = "moonscape-2022-04-19";
    description = "3D wallpaper for Nix";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/bcdd2770f5f4839fddc9b503e68db2bc3a87ca4d/wallpapers/nix-wallpaper-moonscape.png";
      hash = "sha256-AR3W8avHzQLxMNLfD/A1efyZH+vAdTLKllEhJwBl0xc=";
    };
    license = lib.licenses.cc-by-sa-40;
  };

  mosaic-blue = mkNixBackground {
    name = "mosaic-blue-2016-02-19";
    description = "Mosaic blue background for Nix";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/766f10e0c93cb1236a85925a089d861b52ed2905/wallpapers/nix-wallpaper-mosaic-blue.png";
      hash = "sha256-xZbNK8s3/ooRvyeHGxhcYnnifeGAiAnUjw9EjJTWbLE=";
    };
    license = lib.licenses.cc0;
  };

  nineish = mkNixBackground {
    name = "nineish-2019-12-04";
    description = "Nix background inspired by simpler times";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/da01f68d21ddfdc9f1c6e520c2170871c81f1cf5/wallpapers/nix-wallpaper-nineish.png";
      hash = "sha256-EMSD1XQLaqHs0NbLY0lS1oZ4rKznO+h9XOGDS121m9c=";
    };
    license = lib.licenses.cc-by-sa-40;
  };

  nineish-dark-gray = mkNixBackground {
    name = "nineish-dark-gray-2020-07-02";
    description = "Dark gray Nix background inspired by simpler times";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/f07707cecfd89bc1459d5dad76a3a4c5315efba1/wallpapers/nix-wallpaper-nineish-dark-gray.png";
      hash = "sha256-nhIUtCy/Hb8UbuxXeL3l3FMausjQrnjTVi1B3GkL9B8=";
    };
    license = lib.licenses.cc-by-sa-40;
  };

  nineish-solarized-dark = mkNixBackground {
    name = "nineish-dark-gray-2021-07-20";
    description = "Solarized dark Nix background inspired by simpler times";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/f99638d8d1a11d97a99ff7e0e1e7df58c28643ff/wallpapers/nix-wallpaper-nineish-solarized-dark.png";
      hash = "sha256-ZBrk9izKvsY4Hzsr7YovocCbkRVgUN9i/y1B5IzOOKo=";
    };
    license = lib.licenses.cc-by-sa-40;
  };

  nineish-solarized-light = mkNixBackground {
    name = "nineish-dark-light-2021-07-20";
    description = "Solarized light Nix background inspired by simpler times";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/f99638d8d1a11d97a99ff7e0e1e7df58c28643ff/wallpapers/nix-wallpaper-nineish-solarized-light.png";
      hash = "sha256-gb5s5ePdw7kuIL3SI8VVhOcLcHu0cHMJJ623vg1kz40=";
    };
    license = lib.licenses.cc-by-sa-40;
  };

  nineish-catppuccin-frappe-alt = mkNixBackground {
    name = "nineish-catppuccin-frappe-alt-2025-01-27";
    description = "Alternative Catppuccin Frappe wallpaper for Nix inspired by simpler times";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/33856d7837cb8ba76c4fc9e26f91a659066ee31f/wallpapers/nix-wallpaper-nineish-catppuccin-frappe-alt.png";
      hash = "sha256-ZbtgfBE09FhCTPPCzDlOrSoRUmv1lmhxiNTvHDldF/4=";
    };
    license = lib.licenses.cc-by-sa-40;
  };

  nineish-catppuccin-frappe = mkNixBackground {
    name = "nineish-catppuccin-frappe-2025-01-27";
    description = "Catppuccin Frappe wallpaper for Nix inspired by simpler times";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/33856d7837cb8ba76c4fc9e26f91a659066ee31f/wallpapers/nix-wallpaper-nineish-catppuccin-frappe.png";
      hash = "sha256-/HAtpGwLxjNfJvX5/4YZfM8jPNStaM3gisK8+ImRmQ4=";
    };
    license = lib.licenses.cc-by-sa-40;
  };

  nineish-catppuccin-latte-alt = mkNixBackground {
    name = "nineish-catppuccin-latte-alt-2025-01-27";
    description = "Alternative Catppuccin Latte wallpaper for Nix inspired by simpler times";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/33856d7837cb8ba76c4fc9e26f91a659066ee31f/wallpapers/nix-wallpaper-nineish-catppuccin-latte-alt.png";
      hash = "sha256-UyUQ4YQYlJrjoUX6qU6cGWjhA1AnIpQgniQermUtO2w=";
    };
    license = lib.licenses.cc-by-sa-40;
  };

  nineish-catppuccin-latte = mkNixBackground {
    name = "nineish-catppuccin-latte-2025-01-27";
    description = "Catppuccin Latte wallpaper for Nix inspired by simpler times";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/33856d7837cb8ba76c4fc9e26f91a659066ee31f/wallpapers/nix-wallpaper-nineish-catppuccin-latte.png";
      hash = "sha256-+DirQiQ1TUeB+e2AeJD8mWjt0OTWtrqkeqZrVr5v5iY=";
    };
    license = lib.licenses.cc-by-sa-40;
  };

  nineish-catppuccin-macchiato-alt = mkNixBackground {
    name = "nineish-catppuccin-macchiato-alt-2025-01-27";
    description = "Alternative Catppuccin Macchiato wallpaper for Nix inspired by simpler times";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/33856d7837cb8ba76c4fc9e26f91a659066ee31f/wallpapers/nix-wallpaper-nineish-catppuccin-macchiato-alt.png";
      hash = "sha256-OUT0SsToRH5Zdd+jOwhr9iVBoVNUKhUkJNBYFDKZGOU=";
    };
    license = lib.licenses.cc-by-sa-40;
  };

  nineish-catppuccin-macchiato = mkNixBackground {
    name = "nineish-catppuccin-macchiato-2025-01-27";
    description = "Catppuccin Macchiato wallpaper for Nix inspired by simpler times";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/33856d7837cb8ba76c4fc9e26f91a659066ee31f/wallpapers/nix-wallpaper-nineish-catppuccin-macchiato.png";
      hash = "sha256-1JWgytxOvI0hwkCk+1hdZqhLB0u5aHEyEcsmlo4kMuw=";
    };
    license = lib.licenses.cc-by-sa-40;
  };

  nineish-catppuccin-mocha-alt = mkNixBackground {
    name = "nineish-catppuccin-mocha-alt-2025-01-27";
    description = "Alternative Catppuccin Mocha wallpaper for Nix inspired by simpler times";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/33856d7837cb8ba76c4fc9e26f91a659066ee31f/wallpapers/nix-wallpaper-nineish-catppuccin-mocha-alt.png";
      hash = "sha256-ThDrZIJIyO2DdIW41sV6iYyCNhM89cwHr8l6DAfbXjI=";
    };
    license = lib.licenses.cc-by-sa-40;
  };

  nineish-catppuccin-mocha = mkNixBackground {
    name = "nineish-catppuccin-mocha-2025-01-27";
    description = "Catppuccin Mocha wallpaper for Nix inspired by simpler times";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/33856d7837cb8ba76c4fc9e26f91a659066ee31f/wallpapers/nix-wallpaper-nineish-catppuccin-mocha.png";
      hash = "sha256-zlYqSid5Q1L5sUrAcvR+7aN2jImiuoR9gygBRk8x9Wo=";
    };
    license = lib.licenses.cc-by-sa-40;
  };

  recursive = mkNixBackground {
    name = "recursive-2022-04-19";
    description = "3D wallpaper for Nix";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/bcdd2770f5f4839fddc9b503e68db2bc3a87ca4d/wallpapers/nix-wallpaper-recursive.png";
      hash = "sha256-YvFrlysNGMwJ7eMFOoz0KI8AjoPN3ao+AVOgnVZzkFE=";
    };
    license = lib.licenses.cc-by-sa-40;
  };

  simple-blue = mkNixBackground {
    name = "simple-blue-2016-02-19";
    description = "Simple blue background for Nix";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/766f10e0c93cb1236a85925a089d861b52ed2905/wallpapers/nix-wallpaper-simple-blue.png";
      hash = "sha256-utrcjzfeJoFOpUbFY2eIUNCKy5rjLt57xIoUUssJmdI=";
    };
    license = lib.licenses.cc0;
  };

  simple-dark-gray = mkNixBackground {
    name = "simple-dark-gray-2016-02-19";
    description = "Simple dark gray background for Nix";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/766f10e0c93cb1236a85925a089d861b52ed2905/wallpapers/nix-wallpaper-simple-dark-gray.png";
      hash = "sha256-JaLHdBxwrphKVherDVe5fgh+3zqUtpcwuNbjwrBlAok=";
    };
    license = lib.licenses.cc0;
  };

  simple-dark-gray-bootloader = mkNixBackground {
    name = "simple-dark-gray-bootloader-2018-08-28";
    description = "Simple dark gray background for NixOS, specifically bootloaders";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/9d1f11f652ed5ffe460b6c602fbfe2e7e9a08dff/bootloader/nix-wallpaper-simple-dark-gray_bootloader.png";
      hash = "sha256-Sd52CEw/pHmk6Cs+yrM/8wscG9bvYuECylQd27ybRmw=";
    };
    # license not clarified
  };

  simple-dark-gray-bottom = mkNixBackground {
    name = "simple-dark-gray-2018-08-28";
    description = "Simple dark gray background for NixOS, specifically bootloaders and graphical login";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/783c38b22de09f6ee33aacc817470a4513392d83/wallpapers/nix-wallpaper-simple-dark-gray_bottom.png";
      hash = "sha256-JUyzf9dYRyLQmxJPKptDxXL7yRqAFt5uM0C9crkkEY4=";
    };
    # license not clarified
  };

  simple-light-gray = mkNixBackground {
    name = "simple-light-gray-2016-02-19";
    description = "Simple light gray background for Nix";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/766f10e0c93cb1236a85925a089d861b52ed2905/wallpapers/nix-wallpaper-simple-light-gray.png";
      hash = "sha256-Ylo5H5OrU/t9vwLbfO0OyPIsB/0vS5iUPTt/G3YHzUQ=";
    };
    license = lib.licenses.cc0;
  };

  simple-red = mkNixBackground {
    name = "simple-red-2016-02-19";
    description = "Simple red background for Nix";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/766f10e0c93cb1236a85925a089d861b52ed2905/wallpapers/nix-wallpaper-simple-red.png";
      hash = "sha256-WnKjgvnn5Rg4R3xaJQ2mhBHQqCfl9jV6Xx3hEXW+uZk=";
    };
    license = lib.licenses.cc0;
  };

  stripes-logo = mkNixBackground {
    name = "stripes-logo-2016-02-19";
    description = "Stripes logo background for Nix";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/766f10e0c93cb1236a85925a089d861b52ed2905/wallpapers/nix-wallpaper-stripes-logo.png";
      hash = "sha256-1MoPwytw8kBiy+Sx70xmHnxMJgqEaOR9YEgQMO6bEjM=";
    };
    license = lib.licenses.cc0;
  };

  stripes = mkNixBackground {
    name = "stripes-2016-02-19";
    description = "Stripes background for Nix";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/766f10e0c93cb1236a85925a089d861b52ed2905/wallpapers/nix-wallpaper-stripes.png";
      hash = "sha256-o3GqbFZ/18ScLOlAL6GRy54l8P/U6wUeeK4HtPkZw4Q=";
    };
    license = lib.licenses.cc0;
  };

  waterfall = mkNixBackground {
    name = "waterfall-2022-04-19";
    description = "3D wallpaper for Nix";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/bcdd2770f5f4839fddc9b503e68db2bc3a87ca4d/wallpapers/nix-wallpaper-waterfall.png";
      hash = "sha256-ULFNUZPU9khDG6rtkMskLe5sYpUcrJVvcFvEkpvXjMM=";
    };
    license = lib.licenses.cc-by-sa-40;
  };

  watersplash = mkNixBackground {
    name = "watersplash-2022-04-19";
    description = "3D wallpaper for Nix";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/bcdd2770f5f4839fddc9b503e68db2bc3a87ca4d/wallpapers/nix-wallpaper-watersplash.png";
      hash = "sha256-6Gdjzq3hTvUH7GeZmZnf+aOQruFxReUNEryAvJSgycQ=";
    };
    license = lib.licenses.cc-by-sa-40;
  };

}
