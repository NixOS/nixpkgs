{ stdenvNoCC
, lib
, fetchFromGitHub
}:
stdenvNoCC.mkDerivation rec {
  pname = "deepin-desktop-base";
  version = "2023.09.05";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-Gqp56TbkuTOI3aT7UmRuYBjUwRiOoIUHiRf0DaY0yew=";
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
