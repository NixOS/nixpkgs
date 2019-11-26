{ autoconf-archive, autoreconfHook, cinnamon-desktop, colord, fetchFromGitHub, glib, gsettings_desktop_schemas, gtk3, intltool, lcms2, libcanberra, libcanberra_gtk3, libgnomekbd, libnotify, libxklavier, makeWrapper, pkgconfig, pulseaudio, stdenv, systemd, upower }:

stdenv.mkDerivation rec {
  pname = "cinnamon-settings-daemon";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon-settings-daemon";
    rev = "${version}";
    sha256 = "1jfhjizifm2pkf66jggvdvxlsmq1jhzphpa5m8q1kybva57nxnms";
  };

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  buildInputs = [ autoconf-archive cinnamon-desktop colord gtk3 glib gsettings_desktop_schemas intltool lcms2 libcanberra libcanberra_gtk3 libgnomekbd libnotify libxklavier makeWrapper pkgconfig pulseaudio systemd upower ];
  nativeBuildInputs = [ autoreconfHook ];

  postFixup  = ''
    for f in "$out/libexec/"*; do
      wrapProgram "$f" --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
    done
  '';
}
