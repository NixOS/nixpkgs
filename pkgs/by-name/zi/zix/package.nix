{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "zix";
  version = "0.8.0";

  src = fetchFromGitLab {
    owner = "drobilla";
    repo = "zix";
    rev = "v${version}";
    hash = "sha256-742N2U/3viVzmyfCHFezpDCuzLzquCgoDlrdOtcxkUI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  mesonFlags = [
    "-Dbenchmarks=disabled"
    "-Ddocs=disabled"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Lightweight C99 portability and data structure library";
    homepage = "https://gitlab.com/drobilla/zix";
    changelog = "https://gitlab.com/drobilla/zix/-/blob/${src.rev}/NEWS";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
