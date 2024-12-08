{
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
  version = "1.1.1";

  src = fetchFromGitLab {
    owner = "emilua";
    repo = "beast";
    rev = "v${self.version}";
    hash = "sha256-8pHL0ut221LvFwb/o1GuLV3gIDw5LSeqxqIa9eaQjXY=";
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
})
