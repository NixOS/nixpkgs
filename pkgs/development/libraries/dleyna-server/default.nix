{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  meson,
  ninja,
  makeWrapper,
  pkg-config,
  dleyna-core,
  dleyna-connector-dbus,
  gssdp,
  gupnp,
  gupnp-av,
  gupnp-dlna,
  libsoup,
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

  patches = [
    # Fix build with meson 1.2. We use the gentoo patch intead of the
    # usptream one because the latter only applies on the libsoup_3 based
    # merged dLeyna project.
    # https://gitlab.gnome.org/World/dLeyna/-/merge_requests/6
    (fetchpatch {
      url = "https://github.com/gentoo/gentoo/raw/2e3a1f4f7a1ef0c3e387389142785d98b5834e60/net-misc/dleyna-server/files/meson-1.2.0.patch";
      sha256 = "sha256-/p2OaPO5ghWtPotwIir2TtcFF5IDFN9FFuyqPHevuFI=";
    })
  ];

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
