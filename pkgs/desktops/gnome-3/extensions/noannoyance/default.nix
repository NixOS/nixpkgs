{ stdenv
, lib
, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "noannoyance";
  version = "unstable-2021-01-17";

  src = fetchFromGitHub {
    owner = "BjoernDaase";
    repo = "noannoyance";
    rev = "f6e76916336aee2f7c4141796f3c40c870d2b347";
    sha256 = "1iy3nif8rjjcwf83fg9ds93fi7vmhliynmlwqnx036s3msmxvgs3";
  };

  uuid = "noannoyance@daase.net";

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp metadata.json extension.js $out/share/gnome-shell/extensions/${uuid}
  '';

  meta = with lib; {
    description = "Removes the 'Window is ready' notification and puts the window into focus";
    homepage = "https://github.com/BjoernDaase/noannoyance";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ tu-maurice ];
  };
}
