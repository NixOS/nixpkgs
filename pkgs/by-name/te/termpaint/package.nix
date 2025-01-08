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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "termpaint";
    repo = "termpaint";
    rev = final.version;
    hash = "sha256-AsbUJjz51pedmemI0racMgWRzpbIeNJrK/walFUniR4=";
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
