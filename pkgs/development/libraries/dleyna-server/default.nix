{ stdenv, autoreconfHook, makeWrapper, pkgconfig, fetchFromGitHub, dleyna-core, dleyna-connector-dbus, gssdp, gupnp, gupnp-av, gupnp-dlna, libsoup }:

stdenv.mkDerivation rec {
  name = "dleyna-server";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "01org";
    repo = name;
    rev = "${version}";
    sha256 = "13a2i6ms27s46yxdvlh2zm7pim7jmr5cylnygzbliz53g3gxxl3j";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig makeWrapper ];
  buildInputs = [ dleyna-core dleyna-connector-dbus gssdp gupnp gupnp-av gupnp-dlna libsoup ];

  preFixup = ''
    wrapProgram "$out/libexec/dleyna-server-service" \
      --set DLEYNA_CONNECTOR_PATH "$DLEYNA_CONNECTOR_PATH"
  '';

  meta = with stdenv.lib; {
    description = "Library to discover, browse and manipulate Digital Media Servers";
    homepage = http://01.org/dleyna;
    maintainers = [ maintainers.jtojnar ];
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
