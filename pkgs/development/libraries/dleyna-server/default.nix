{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, makeWrapper
, pkg-config
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
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "phako";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jlF9Lr/NG+Fsy/bB7aLb7xOLqel8GueJK5luo9rsDME=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper
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
    wrapProgram "$out/libexec/dleyna-server-service" \
      --set DLEYNA_CONNECTOR_PATH "$DLEYNA_CONNECTOR_PATH"
  '';

  meta = with lib; {
    description = "Library to discover, browse and manipulate Digital Media Servers";
    homepage = "https://github.com/phako/dleyna-server";
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
    license = licenses.lgpl21Only;
  };
}
