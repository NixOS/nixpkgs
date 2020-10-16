{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-paperwm";
  version = "38.0";

  src = fetchFromGitHub {
    owner = "paperwm";
    repo = "PaperWM";
    rev = version;
    sha256 = "01r2ifwrl8w735d0ckzlwhvclax9dxd2ld5y2svv5bp444zbjsag";
  };

  uuid = "paperwm@hedning:matrix.org";

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r . $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Tiled scrollable window management for Gnome Shell";
    homepage = "https://github.com/paperwm/PaperWM";
    license = licenses.gpl3;
    maintainers = with maintainers; [ hedning zowoq ];
  };
}
