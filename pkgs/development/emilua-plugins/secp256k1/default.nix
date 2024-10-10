{
  lib,
  stdenv,
  meson,
  ninja,
  fetchFromGitLab,
  gperf,
  gawk,
  gitUpdater,
  pkg-config,
  boost,
  luajit_openresty,
  asciidoctor,
  emilua,
  liburing,
  openssl,
  fmt,
  secp256k1,
}:

stdenv.mkDerivation rec {
  pname = "emilua-secp256k1";
  version = "0.5.0";

  src = fetchFromGitLab {
    owner = "emilua";
    repo = "secp256k1";
    rev = "v${version}";
    hash = "sha256-xbyDKxuU03U0k4YSD7Sahw2Z4ZSpQHwrpWcSN0F5CCw=";
  };

  buildInputs = [
    emilua
    liburing
    fmt
    secp256k1
    luajit_openresty
    openssl
    boost
  ];

  nativeBuildInputs = [
    gperf
    gawk
    pkg-config
    asciidoctor
    meson
    ninja
  ];

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = with lib; {
    description = "Emilua bindings to libsecp256k1";
    homepage = "https://emilua.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ manipuladordedados ];
    platforms = platforms.linux;
  };
}
