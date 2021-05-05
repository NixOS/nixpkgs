{ stdenv, lib, fetchFromGitHub, glib, nodePackages }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-pop-shell";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "shell";
    rev = version;
    sha256 = "1ba1nrnk4cqgjx5mygqdkw74xlankrkiib9rw0vwkjcgv9bj024a";
  };

  makeFlags = [ "DESTDIR=$(out)" ];
  buildInputs = [ glib nodePackages.typescript ];

  postInstall = ''
    mv $out/usr/* $out
    rmdir $out/usr
  '';

  meta = with lib; {
    description = "A tiling extension for the GNOME Shell";
    longDescription = ''
      A keyboard-driven layer for GNOME Shell which allows for quick and
      sensible navigation and management of windows. The core feature of Pop
      Shell is the addition of advanced tiling window management.
    '';
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    homepage = src.meta.homepage;
  };
}
