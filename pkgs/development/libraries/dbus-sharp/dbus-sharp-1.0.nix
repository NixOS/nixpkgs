{stdenv, fetchFromGitHub, pkgconfig, mono, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "dbus-sharp";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "mono";
    repo = "dbus-sharp";

    rev = "v${version}";
    sha256 = "13qlqx9wqahfpzzl59157cjxprqcx2bd40w5gb2bs3vdx058p562";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ mono ];

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "D-Bus for .NET";
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
