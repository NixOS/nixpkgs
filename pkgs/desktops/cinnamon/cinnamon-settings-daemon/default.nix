{ autoconf-archive, autoreconfHook, cinnamon-desktop, colord, fetchFromGitHub, glib, gsettings-desktop-schemas, gtk3, intltool, lcms2, libcanberra, libcanberra-gtk3, libgnomekbd, libnotify, libxklavier, makeWrapper, pkgconfig, pulseaudio, stdenv, systemd, upower }:

stdenv.mkDerivation rec {
  pname = "cinnamon-settings-daemon";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "1h74d68a7hx85vv6ak26b85jq0wr56ps9rzfvqsnxwk81zxw2n7q";
  };

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  buildInputs = [ autoconf-archive cinnamon-desktop colord gtk3 glib gsettings-desktop-schemas intltool lcms2 libcanberra libcanberra-gtk3 libgnomekbd libnotify libxklavier makeWrapper pkgconfig pulseaudio systemd upower ];
  nativeBuildInputs = [ autoreconfHook ];

  postFixup  = ''
    for f in "$out/libexec/"*; do
      wrapProgram "$f" --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
    done
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/linuxmint/cinnamon-settings-daemon";
    description = "The settings daemon for the Cinnamon desktop";

    platforms = platforms.linux;
    maintainers = [ maintainers.mkg20001 ];
  };
}
