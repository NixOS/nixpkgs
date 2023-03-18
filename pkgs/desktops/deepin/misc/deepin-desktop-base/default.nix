{ stdenvNoCC
, lib
, fetchFromGitHub
}:
stdenvNoCC.mkDerivation rec {
  pname = "deepin-desktop-base";
  version = "2022.11.15-deepin";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-GTgIHWz+x1Pl3F4zKA9V8o2oq6c53OK94q95WoMG+Qo=";
  };

  makeFlags = [ "DESTDIR=${placeholder "out"}" ];

  # distribution_logo_transparent.svg come form nixos-artwork(https://github.com/NixOS/nixos-artwork)/logo/nixos-white.svg under CC-BY license, used for dde-lock
  postInstall = ''
    rm -r $out/etc
    rm -r $out/usr/share/python-apt
    rm -r $out/usr/share/plymouth
    rm -r $out/usr/share/distro-info
    mv $out/usr/* $out/
    rm -r $out/usr
    install -D ${./distribution_logo_transparent.svg} $out/share/pixmaps/distribution_logo_transparent.svg
  '';

  meta = with lib; {
    description = "Base assets and definitions for Deepin Desktop Environment";
    homepage = "https://github.com/linuxdeepin/deepin-desktop-base";
    license = with licenses; [ gpl3Plus cc-by-40 ];
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
