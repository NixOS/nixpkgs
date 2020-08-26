{ stdenv, fetchgit, gettext, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-draw-on-your-screen";
  version = "6";

  src = fetchgit {
    url = "https://framagit.org/abakkk/DrawOnYourScreen/";
    rev = "v${version}";
    sha256 = "05i20ii8lv6mg56rz8lng80dx35l6g45j8wr7jgbp591hg0spj1w";
  };

  uuid = "drawOnYourScreen@abakkk.framagit.org";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r . $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "A drawing extension for GNOME Shell";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ericdallo ];
    platforms = gnome3.gnome-shell.meta.platforms;
    homepage = "https://framagit.org/abakkk/DrawOnYourScreen";
  };
}
