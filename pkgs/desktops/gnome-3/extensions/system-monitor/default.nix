{ stdenv, substituteAll, fetchFromGitHub, glib, glib-networking, libgtop, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-system-monitor";
  version = "38";

  src = fetchFromGitHub {
    owner = "paradoxxxzero";
    repo = "gnome-shell-system-monitor-applet";
    rev = "v${version}";
    sha256 = "1sdj2kxb418mgq44a6lf6jic33wlfbnn3ja61igmx0jj1530iknv";
  };

  buildInputs = [
    glib
    glib-networking
    libgtop
  ];

  patches = [
    (substituteAll {
      src = ./paths_and_nonexisting_dirs.patch;
      gtop_path = "${libgtop}/lib/girepository-1.0";
      glib_net_path = "${glib-networking}/lib/girepository-1.0";
    })
  ];

  buildPhase = ''
    glib-compile-schemas --targetdir=${uuid}/schemas ${uuid}/schemas
  '';

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ${uuid} $out/share/gnome-shell/extensions
  '';

  uuid = "system-monitor@paradoxxx.zero.gmail.com";

  meta = with stdenv.lib; {
    description = "Display system informations in gnome shell status bar";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ tiramiseb ];
    homepage = https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet;
    # 3.36 support not yet ready
    # https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet/pull/564
    broken = stdenv.lib.versionAtLeast gnome3.gnome-shell.version "3.34";
  };
}
