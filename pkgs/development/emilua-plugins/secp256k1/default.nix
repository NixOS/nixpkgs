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
  version = "0.5.1";

  src = fetchFromGitLab {
    owner = "emilua";
    repo = "secp256k1";
    rev = "v${version}";
    hash = "sha256-u3o6kE1HykxH2KbrJmNTDz9IbT+e26Vxze5RzvfCfVA=";
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
