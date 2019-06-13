{ stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, makeWrapper
, pkgconfig
, dleyna-core
, dleyna-connector-dbus
, gssdp
, gupnp
, gupnp-av
, gupnp-dlna
, libsoup
}:

stdenv.mkDerivation rec {
  pname = "dleyna-server";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "01org";
    repo = pname;
    rev = version;
    sha256 = "13a2i6ms27s46yxdvlh2zm7pim7jmr5cylnygzbliz53g3gxxl3j";
  };

  patches = [
    # fix build with gupnp 1.2
    # https://github.com/intel/dleyna-server/pull/161
    (fetchpatch {
      url = https://github.com/intel/dleyna-server/commit/96c01c88363d6e5e9b7519bc4e8b5d86cf783e1f.patch;
      sha256 = "0p8fn331x2whvn6skxqvfzilx0m0yx2q5mm2wh2625l396m3fzmm";
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
    wrapProgram "$out/libexec/dleyna-server-service" \
      --set DLEYNA_CONNECTOR_PATH "$DLEYNA_CONNECTOR_PATH"
  '';

  meta = with stdenv.lib; {
    description = "Library to discover, browse and manipulate Digital Media Servers";
    homepage = https://01.org/dleyna;
    maintainers = [ maintainers.jtojnar ];
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
