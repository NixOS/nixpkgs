{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  libx11,
  libxft,
  fontconfig,
  libxcrypt,
  freetype,
  ncurses,
  zlib,
  gpm,
  withX11 ? true,
  withXft ? withX11,
  withGpm ? stdenv.hostPlatform.isLinux,
}:
assert lib.assertMsg (withXft -> withX11) "xft requires x11";
assert lib.assertMsg (withGpm -> stdenv.hostPlatform.isLinux) "gpm is only supported in linux";

stdenv.mkDerivation (finalAttrs: {
  pname = "twin";
  version = "1.0.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "cosmos72";
    repo = "twin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k8pYGNfIfVf+oQbivYTkiQtJzeXX0ftrArVV8SEOAH0=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libxcrypt
    ncurses
    zlib
  ]
  ++ lib.optional withX11 libx11
  ++ lib.optionals withXft [
    libxft
    freetype
    fontconfig
  ]
  ++ lib.optional withGpm gpm;

  configureFlags = [
    "--enable-server-static=no"
    "--enable-socket=yes"
    "--enable-hw-tty=yes"
    "--enable-hw-twin=yes"
    "--enable-hw-display=yes"
    "--enable-hw-termcap=yes"
    "--enable-rcparse=yes"
    (lib.enableFeature withX11 "hw-x11")
    (lib.enableFeature withXft "hw-xft")
    (lib.enableFeature withGpm "hw-tty-linux")
  ];

  outputs = [
    "bin"
    "lib"
    "dev"
    "man"
    "out"
  ];

  enableParallelBuilding = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Text mode window environment";
    homepage = "https://github.com/cosmos72/twin";
    changelog = "https://github.com/cosmos72/twin/blob/${finalAttrs.src.rev}/Changelog.txt";
    license = with lib.licenses; [
      gpl2Only
      lgpl2Only
    ];
    maintainers = with lib.maintainers; [ ricardomaps ];
    mainProgram = "twin";
    platforms = lib.platforms.unix;
  };
})
