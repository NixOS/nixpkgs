{ lib, stdenv, fetchFromGitHub, pkg-config, mono, dbus-sharp-2_0, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "dbus-sharp-glib";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "mono";
    repo = "dbus-sharp-glib";

    rev = "v${version}";
    sha256 = "0i39kfg731as6j0hlmasgj8dyw5xsak7rl2dlimi1naphhffwzm8";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ mono dbus-sharp-2_0 ];

  dontStrip = true;

  meta = with lib; {
    description = "D-Bus for .NET: GLib integration module";
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
