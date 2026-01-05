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
  version = "0.6.2";

  src = fetchFromGitLab {
    owner = "drobilla";
    repo = "zix";
    rev = "v${version}";
    hash = "sha256-1fdW014QKvTYHaEmDsivUVPzF/vZgnW3Srk6edp6G1o=";
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
