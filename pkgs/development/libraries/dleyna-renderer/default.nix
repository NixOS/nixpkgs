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
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "phako";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bGasT3XCa7QHV3D7z59TSHoqWksNSIgaO0z9zYfHHuw=";
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
    platforms = platforms.unix;
    license = licenses.lgpl21Only;
  };
}
