{ stdenv, fetchurl, pkgs, lib, alsa-lib }:

stdenv.mkDerivation rec {
  pname = "tabby-terminal";
  version = "1.0.207";
  src = fetchurl {
    url = "https://github.com/Eugeny/tabby/releases/download/v${version}/tabby-${version}-linux-x64.deb";
    hash = "sha256-PTTkL3+mYb7KM8fDUmgCuAF2lU88fYOstGWp/O5WZas=";
  };

  nativeBuildInputs = with pkgs; [
    dpkg
    makeWrapper
  ];

  buildInputs = with pkgs; [
    glib
    nss
    nspr
    atk
    cups
    dbus
    libdrm
    gtk3
    pango
    cairo
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    libxkbcommon
    mesa
    expat
    xorg.libxcb
    alsa-lib
    libGL
    libsecret
    musl
  ];

  postInstall = ''
    mkdir -p $out/{opt,bin}
    cp -r opt $out
    wrapProgram "$out/opt/Tabby/tabby" --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations}} --no-sandbox" --set LD_LIBRARY_PATH=${lib.makeLibraryPath buildInputs}
    cp -r usr/* $out

    ln -s $out/opt/Tabby/tabby $out/bin/tabby

    substituteInPlace $out/share/applications/tabby.desktop \
      --replace "/opt" $out/opt
  '';

  meta = with lib; {
    homepage = "https://tabby.sh";
    description = "A terminal for a more modern age";
    license = licenses.mit;
    maintainers = with maintainers; [ ChocolateLoverRaj ];
    mainProgram = "tabby";
    platforms = platforms.linux;
    downloadPage = "https://github.com/Eugeny/tabby/releases/latest";
  };
}
