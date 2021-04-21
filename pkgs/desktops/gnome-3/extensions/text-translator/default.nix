{ stdenv, fetchFromGitHub, gnome3, gst_all_1, pkgs, substituteAll, translate-shell, clutter }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-text-translator";
  version = "unstable-2020-02-25";

  src = fetchFromGitHub {
    owner = "gufoe";
    repo = "text-translator";
    rev = "991daadff538bd7acd15cf60415704e0215f2bf6";
    sha256 = "098a967p1gr8g20nz0fdnlmpc6k40fh0ijqcdhp7ckfqr39imkhr";
  };

  uuid = "text_translator@awamper.gmail.com";

  patches = [
    (substituteAll {
      src = ./fix-deps.patch;
      trans = "${translate-shell}/bin/trans";
      clutter = "${clutter}/lib/girepository-1.0";
      gstBase = "${gst_all_1.gst-plugins-base}/lib/gstreamer-1.0";
    })
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r . $out/share/gnome-shell/extensions/${uuid}
    runHook preInstall
  '';

  meta = with stdenv.lib; {
    description = "A text translator extension for GNOME Shell";
    license = licenses.unfree;
    maintainers = with maintainers; [ ericdallo ];
    platforms = gnome3.gnome-shell.meta.platforms;
    homepage = "https://github.com/gufoe/text-translator";
  };
}
