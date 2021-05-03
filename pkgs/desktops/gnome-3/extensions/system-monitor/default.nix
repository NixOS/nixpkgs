{ lib, stdenv, substituteAll, fetchFromGitHub, glib, glib-networking, libgtop, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-system-monitor";
  version = "unstable-2021-04-08";

  src = fetchFromGitHub {
    owner = "paradoxxxzero";
    repo = "gnome-shell-system-monitor-applet";
    rev = "942603da39de12f50b1f86efbde92d7526d1290e";
    sha256 = "0lzb7064bigw2xsqkzr8qfhp9wfmxyi3823j2782v99jpcz423aw";
  };

  buildInputs = [
    glib
    glib-networking
    libgtop
  ];

  patches = [
    (substituteAll {
      src = ./paths_and_nonexisting_dirs.patch;
      clutter_path = gnome3.mutter.libdir; # this should not be used in settings but 🤷‍♀️
      gtop_path = "${libgtop}/lib/girepository-1.0";
      glib_net_path = "${glib-networking}/lib/girepository-1.0";
    })
  ];

  buildPhase = ''
    runHook preBuild
    glib-compile-schemas --targetdir=${uuid}/schemas ${uuid}/schemas
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ${uuid} $out/share/gnome-shell/extensions
    runHook postInstall
  '';

  uuid = "system-monitor@paradoxxx.zero.gmail.com";

  meta = with lib; {
    description = "Display system informations in gnome shell status bar";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ tiramiseb ];
    homepage = "https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet";
  };
}
