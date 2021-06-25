{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-gtile";
  version = "44";

  src = fetchFromGitHub {
    owner = "gTile";
    repo = "gTile";
    rev = "V${version}";
    sha256 = "0i00psc1ky70zljd14jzr627y7nd8xwnwrh4xpajl1f6djabh12s";
  };

  uuid = "gTile@vibou";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r * $out/share/gnome-shell/extensions/${uuid}

    runHook postInstall
  '';

  meta = with lib; {
    description = "A window tiling extension for Gnome. This is the new official home of the vibou.gTile extension.";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ mdsp ];
    platforms = platforms.linux;
    homepage = "https://github.com/gTile/gTile";
  };
}
