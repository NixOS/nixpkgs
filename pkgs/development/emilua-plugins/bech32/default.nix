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
  cmake,
  range-v3,
}:

stdenv.mkDerivation rec {
  pname = "emilua-bech32";
  version = "1.1.0";

  src = fetchFromGitLab {
    owner = "emilua";
    repo = "bech32";
    rev = "v${version}";
    hash = "sha256-f4KFL2RV+fAVJrgaAQWKuLwlN440j9vBbiyk5fHrwiE=";
  };

  buildInputs = [
    emilua
    liburing
    fmt
    range-v3
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
    cmake
  ];

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = with lib; {
    description = "Bech32 codec for Emilua";
    homepage = "https://emilua.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ manipuladordedados ];
    platforms = platforms.linux;
  };
}
