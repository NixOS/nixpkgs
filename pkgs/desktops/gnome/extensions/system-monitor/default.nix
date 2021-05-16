{ lib, stdenv, substituteAll, fetchFromGitHub, glib, glib-networking, libgtop, gnome }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-system-monitor";
  version = "unstable-2021-05-04";

  src = fetchFromGitHub {
    owner = "paradoxxxzero";
    repo = "gnome-shell-system-monitor-applet";
    rev = "bc38ccf49ac0ffae0fc0436f3c2579fc86949f10";
    sha256 = "0yb5sb2xv4m18a24h4daahnxgnlmbfa0rfzic0zs082qv1kfi5h8";
  };

  buildInputs = [
    glib
    glib-networking
    libgtop
  ];

  patches = [
    (substituteAll {
      src = ./paths_and_nonexisting_dirs.patch;
      clutter_path = gnome.mutter.libdir; # this should not be used in settings but 🤷‍♀️
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
