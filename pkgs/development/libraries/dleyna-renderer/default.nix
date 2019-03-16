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
    (fetchurl {
      name = "gupnp-1.2.diff";
      url = https://git.archlinux.org/svntogit/packages.git/plain/trunk/gupnp-1.2.diff?h=packages/dleyna-renderer&id=30b426a1e0ca5857031ed6296bc192d11bd7c5db;
      sha256 = "0x5vj5zfk95avyg6g3nf6gar250cfrgla2ixj2ifn8pcick2d9vq";
    })
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
