{ stdenv, lib, pkgs, fetchurl, writeText }:

let
  sddm_metadata = writeText "sddm_metadata.desktop" ''
    [SddmGreeterTheme]
    Name=Breeze
    Description=NixOS Theme
    Author=David Edmundson and NixOS
    Copyright=(c) 2014, David Edmundson and NixOS
    License=CC-BY-SA
    Type=sddm-theme
    Version=0.1
    Website=https://nixos.org
    Screenshot=breeze.jpg
    MainScript=Main.qml
    ConfigFile=theme.conf
    TranslationsDirectory=translations
    Email=davidedmundson@kde.org
    Theme-Id=nixos
    Theme-API=2.0
  '';

  plasma_metadata = writeText "plasma_metadata.desktop" ''
    [Desktop Entry]
    Comment=NixOS Breeze Desktop Design Language by the KDE VDG and NixOS
    Encoding=UTF-8
    Keywords=Desktop;Workspace;Appearance;Look and Feel;Logout;Lock;Suspend;Shutdown;Hibernate;
    Name=Breeze_NixOS
    Type=Service

    X-KDE-ServiceTypes=Plasma/LookAndFeel
    X-KDE-ParentApp=
    X-KDE-PluginInfo-Author=KDE Visual Design Group and NixOS
    X-KDE-PluginInfo-Category=
    X-KDE-PluginInfo-Email=plasma-devel@kde.org
    X-KDE-PluginInfo-License=GPLv2+
    X-KDE-PluginInfo-Name=org.nixos.breeze.desktop
    X-KDE-PluginInfo-Version=2.0
    X-KDE-PluginInfo-Website=http://www.nixos.org
    X-Plasma-MainScript=defaults
  '';

  pkg_plasma = lib.getBin pkgs.kde5.plasma-workspace;

in stdenv.mkDerivation rec {
  name = "nixos-artwork-2015-02-27";
  # Remember to check the default lightdm wallpaper when updating

  doStrip = false;

  sourceRoot = ./.;

  buildInputs = [ pkg_plasma ];

  GnomeDark = fetchurl {
    url = https://raw.githubusercontent.com/NixOS/nixos-artwork/7ece5356398db14b5513392be4b31f8aedbb85a2/gnome/Gnome_Dark.png;
    sha256 = "0c7sl9k4zdjwvdz3nhlm8i4qv4cjr0qagalaa1a438jigixx27l7";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    gnome=$out/share/artwork/gnome
    mkdir -p $gnome
    ln -s $GnomeDark $gnome/Gnome_Dark.png

    sddm=$out/share/sddm/themes/nixos
    mkdir -p $sddm
    cp -r --no-preserve=mode ${pkg_plasma}/share/sddm/themes/breeze/* $sddm/
    ln -sf $GnomeDark $sddm/components/artwork/background.png
    ln -sf ${sddm_metadata} $sddm/metadata.desktop

    plasma=$out/share/plasma/look-and-feel/org.nixos.breeze.desktop
    mkdir -p $plasma
    cp -r --no-preserve=mode ${pkg_plasma}/share/plasma/look-and-feel/org.kde.breeze.desktop/* $plasma/
    ln -sf $GnomeDark \
       $plasma/contents/components/artwork/background.png
    ln -sf ${plasma_metadata} $plasma/metadata.desktop
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/NixOS/nixos-artwork;
    platforms = platforms.all;
  };
}
