{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  python3,
}:
stdenv.mkDerivation (final: {
  name = "termpaint";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "termpaint";
    repo = "termpaint";
    rev = final.version;
    hash = "sha256-7mfGTC5vJ4806bDbrPMSVthtW05a+M3vgUlHGbtaI4Q=";
  };

  patches = [ ./0001-meson.build-use-prefix.patch ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ];

  mesonFlags = [
    "-Dttyrescue-fexec-blob=false"
    "-Dtools-path=libexec/"
    "-Dttyrescue-path=libexec/"
    "-Dttyrescue-install=true"
  ];

  doCheck = true;

  meta = {
    description = "Low level terminal interface library";
    homepage = "https://github.com/termpaint/termpaint";
    platforms = lib.platforms.unix;
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [
      istoph
      textshell
    ];
  };
})
