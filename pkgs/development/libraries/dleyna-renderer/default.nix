{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, dleyna-connector-dbus
, dleyna-core
, gssdp
, gupnp
, gupnp-av
, gupnp-dlna
, libsoup
, makeWrapper
, docbook-xsl-nons
, libxslt
}:

stdenv.mkDerivation rec {
  pname = "dleyna-renderer";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "phako";
    repo = pname;
    rev = "v${version}";
    sha256 = "EaTE5teMkVDHoJuTLdqcsIL7OyM+tOz85T5D9V3KDoo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper

    # manpage
    docbook-xsl-nons
    libxslt # for xsltproc
  ];

  buildInputs = [
    dleyna-core
    dleyna-connector-dbus # runtime dependency to be picked up to DLEYNA_CONNECTOR_PATH
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

  meta = with lib; {
    description = "Library to discover and manipulate Digital Media Renderers";
    homepage = "https://github.com/phako/dleyna-renderer";
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
    license = licenses.lgpl21Only;
  };
}
