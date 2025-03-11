{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "zix";
  version = "0.4.2";

  src = fetchFromGitLab {
    owner = "drobilla";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nMm3Mdqc4ncCae8SoyGxZYURzmXLNcp1GjsSExfB6x4=";
  };

  patches = [
    # clang-16 support on Darwin:
    #   https://gitlab.com/drobilla/zix/-/issues/3
    (fetchpatch {
      name = "darwin-sync.patch";
      url = "https://gitlab.com/drobilla/zix/-/commit/a6f804073de1f1e626464a9dd0a169fd3f69fdff.patch";
      hash = "sha256-ZkDPjtUzIyqnYarQR+7aCj7S/gSngbd6d75aRT+h7Ww=";
    })
  ];

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
    maintainers = with maintainers; [ yuu ];
  };
}
