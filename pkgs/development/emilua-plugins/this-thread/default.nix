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
}:

stdenv.mkDerivation rec {
  pname = "emilua-this-thread";
  version = "1.0.3";

  src = fetchFromGitLab {
    owner = "emilua";
    repo = "this-thread";
    rev = "v${version}";
    hash = "sha256-3f2nB6KwNka0P7jnvMZF2+ExuTmICj2NswmRWB+YDKo=";
  };

  buildInputs = [
    emilua
    liburing
    fmt
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
    description = "Access C++'s this_thread from Lua";
    homepage = "https://emilua.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ manipuladordedados ];
    platforms = platforms.linux;
  };
}
