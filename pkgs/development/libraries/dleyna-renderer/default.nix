{ stdenv
, fetchurl
, fetchFromGitHub
, autoreconfHook
, pkgconfig
, dleyna-connector-dbus
, dleyna-core
, gssdp
, gupnp
, gupnp-av
, gupnp-dlna
, libsoup
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "dleyna-renderer";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "01org";
    repo = pname;
    rev = version;
    sha256 = "0jy54aq8hgrvzchrvfzqaj4pcn0cfhafl9bv8a9p6j82yjk4pvpp";
  };

  patches = [
    # fix build with gupnp 1.2
    # comes from arch linux packaging https://git.archlinux.org/svntogit/packages.git/tree/trunk/gupnp-1.2.diff?h=packages/dleyna-renderer
    ./gupnp-1.2.diff
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
    makeWrapper
  ];

  buildInputs = [
    dleyna-core
    dleyna-connector-dbus
    gssdp
    gupnp
    gupnp-av
    gupnp-dlna
    libsoup
  ];

  preFixup = ''
    wrapProgram "$out/libexec/dleyna-renderer-service" \
      --set DLEYNA_CONNECTOR_PATH "$DLEYNA_CONNECTOR_PATH"
  '';

  meta = with stdenv.lib; {
    description = "Library to discover and manipulate Digital Media Renderers";
    homepage = https://01.org/dleyna;
    maintainers = [ maintainers.jtojnar ];
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
