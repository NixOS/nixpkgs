{ lib, stdenv, substituteAll, fetchFromGitHub, glib, glib-networking, libgtop, gnome }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-system-monitor";
  version = "unstable-2021-09-07";

  src = fetchFromGitHub {
    owner = "paradoxxxzero";
    repo = "gnome-shell-system-monitor-applet";
    rev = "133f9f32bca5d159515d709bbdee81bf497ebdc5";
    sha256 = "1vz1s1x22xmmzaayrzv5jyzlmxslhfaybbnv959szvfp4mdrhch9";
  };

  buildInputs = [
    glib
    glib-networking
    libgtop
  ];

  patches = [
    (substituteAll {
      src = ./paths_and_nonexisting_dirs.patch;
      clutter_path = gnome.mutter.libdir; # only needed for GNOME < 40.
      gtop_path = "${libgtop}/lib/girepository-1.0";
      glib_net_path = "${glib-networking}/lib/girepository-1.0";
    })
  ];

  buildPhase = ''
    runHook preBuild
    glib-compile-schemas --targetdir="system-monitor@paradoxxx.zero.gmail.com/schemas" "system-monitor@paradoxxx.zero.gmail.com/schemas"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r "system-monitor@paradoxxx.zero.gmail.com" $out/share/gnome-shell/extensions
    runHook postInstall
  '';

  passthru = {
    extensionUuid = "system-monitor@paradoxxx.zero.gmail.com";
    extensionPortalSlug = "system-monitor";
  };

  meta = with lib; {
    description = "Display system informations in gnome shell status bar";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ tiramiseb ];
    homepage = "https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet";
  };
}
