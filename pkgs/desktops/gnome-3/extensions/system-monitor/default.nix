{ stdenv, substituteAll, fetchFromGitHub, glib, glib-networking, libgtop }:

stdenv.mkDerivation rec {
  name = "gnome-shell-system-monitor-${version}";
  version = "36";

  src = fetchFromGitHub {
    owner = "paradoxxxzero";
    repo = "gnome-shell-system-monitor-applet";
    rev = "v${version}";
    sha256 = "0x3r189h5264kjxsm18d34gzb5ih8l4pz7i9qks9slcnzaiw4y0z";
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
    broken = true; # GNOME 3.32 support WIP: https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet/pull/510
    maintainers = with maintainers; [ aneeshusa tiramiseb ];
    homepage = https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet;
  };
}
