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
  botan3,
}:

stdenv.mkDerivation rec {
  pname = "emilua-botan";
  version = "1.1.1";

  src = fetchFromGitLab {
    owner = "emilua";
    repo = "botan";
    rev = "v${version}";
    hash = "sha256-oqJEsVe/mF/v6pCrDDG/Tug4st+LsSlYs4oRvfri8Tc=";
  };

  buildInputs = [
    emilua
    liburing
    fmt
    botan3
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
    description = "Securely clears secrets from memory in Emilua";
    homepage = "https://emilua.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ manipuladordedados ];
    platforms = platforms.linux;
  };
}
