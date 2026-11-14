{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  python3,
  fetchpatch,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "termpaint";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "termpaint";
    repo = "termpaint";
    rev = finalAttrs.version;
    hash = "sha256-7mfGTC5vJ4806bDbrPMSVthtW05a+M3vgUlHGbtaI4Q=";
  };

  patches = [
    ./0001-meson.build-use-prefix.patch

    # fix build w/ glibc-2.44
    (fetchpatch {
      url = "https://github.com/termpaint/termpaint/commit/6164fb5ff17fd3d05bf44e942539082aa71a2ff3.patch";
      hash = "sha256-rTI0ZdJ6Q/a7M73igihd+4EZT9l6l+7oHGUnKmB5n0o=";
    })
  ];

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
