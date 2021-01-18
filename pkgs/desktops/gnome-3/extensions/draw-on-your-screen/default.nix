{ lib, stdenv, fetchgit, gettext, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-draw-on-your-screen";
  version = "10";

  src = fetchgit {
    url = "https://framagit.org/abakkk/DrawOnYourScreen/";
    rev = "v${version}";
    sha256 = "07adzg3mf6k0pmd9lc358w0w3l4pr3p6374day1qhmci2p4zxq6p";
  };

  uuid = "drawOnYourScreen@abakkk.framagit.org";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r . $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';

  meta = with lib; {
    description = "A drawing extension for GNOME Shell";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ericdallo ahuzik ];
    platforms = gnome3.gnome-shell.meta.platforms;
    homepage = "https://framagit.org/abakkk/DrawOnYourScreen";
  };
}
