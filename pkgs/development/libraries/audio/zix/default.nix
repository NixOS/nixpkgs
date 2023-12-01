{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
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

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  mesonFlags = [
    "-Dbenchmarks=disabled"
    "-Ddocs=disabled"
  ];

  env = lib.optionalAttrs stdenv.isDarwin {
    # Do not fail the build on clang-16/darwin.
    # TODO: drop the workaround when upstream fixes it in:
    #   https://gitlab.com/drobilla/zix/-/issues/3
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };

  meta = with lib; {
    description = "A lightweight C99 portability and data structure library";
    homepage = "https://gitlab.com/drobilla/zix";
    changelog = "https://gitlab.com/drobilla/zix/-/blob/${src.rev}/NEWS";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      fogti
      yuu
    ];
  };
}
