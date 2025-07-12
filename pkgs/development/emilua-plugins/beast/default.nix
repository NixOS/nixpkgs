{
  lib,
  stdenv,
  emilua,
  meson,
  gperf,
  ninja,
  asciidoctor,
  pkg-config,
  fetchFromGitLab,
  gitUpdater,
}:

stdenv.mkDerivation (self: {
  pname = "emilua_beast";
  version = "1.1.2";

  src = fetchFromGitLab {
    owner = "emilua";
    repo = "beast";
    rev = "v${self.version}";
    hash = "sha256-MASaZvhIVKmeBUcn/NjlBZ+xh+2RgwHBH2o08lklGa0=";
  };

  buildInputs = [
    emilua
    asciidoctor
    gperf
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Emilua bindings to Boost.Beast (a WebSocket library)";
    homepage = "https://gitlab.com/emilua/beast";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [
      manipuladordedados
      lucasew
    ];
    platforms = lib.platforms.linux;
  };
})
