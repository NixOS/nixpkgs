{stdenv, fetchFromGitHub, pkgconfig, dbus, mono, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "dbus-sharp-${version}";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "mono";
    repo = "dbus-sharp";

    rev = "v${version}";
    sha256 = "1g5lblrvkd0wnhfzp326by6n3a9mj2bj7a7646g0ziwgsxp5w6y7";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ mono ];

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "D-Bus for .NET";
    platforms = platforms.linux;
  };
}
