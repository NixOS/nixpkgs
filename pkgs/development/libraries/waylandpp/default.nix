{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  makeFontsConf,
  pkg-config,
  pugixml,
  wayland,
  libGL,
  libffi,
  buildPackages,
  docSupport ? true,
  doxygen,
  graphviz,
}:

stdenv.mkDerivation rec {
  pname = "waylandpp";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "NilsBrause";
    repo = pname;
    rev = version;
    hash = "sha256-Dw2RnLLyhykikHps1in+euHksO+ERbATbfmbUFOJklg=";
  };

  patches = [
    # Pull fixes for gcc-13 compatibility:
    #   https://github.com/NilsBrause/waylandpp/pull/71
    # Without the change `kodi` fails to find `uint32_t` in `waylandpp`
    # headers.
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/NilsBrause/waylandpp/commit/3c441910aa25f57df2a4db55f75f5d99cea86620.patch";
      hash = "sha256-bxHMP09zCwUKD0M63C1FqQySAN9hr+7t/DyFDRwdtCo=";
    })
  ];

  cmakeFlags =
    [
      "-DCMAKE_INSTALL_DATADIR=${placeholder "dev"}"
    ]
    ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      "-DWAYLAND_SCANNERPP=${buildPackages.waylandpp}/bin/wayland-scanner++"
    ];

  # Complains about not being able to find the fontconfig config file otherwise
  FONTCONFIG_FILE = lib.optional docSupport (makeFontsConf {
    fontDirectories = [ ];
  });

  nativeBuildInputs =
    [
      cmake
      pkg-config
    ]
    ++ lib.optionals docSupport [
      doxygen
      graphviz
    ];
  buildInputs = [
    pugixml
    wayland
    libGL
    libffi
  ];

  outputs =
    [
      "bin"
      "dev"
      "lib"
      "out"
    ]
    ++ lib.optionals docSupport [
      "doc"
      "devman"
    ];

  # Resolves the warning "Fontconfig error: No writable cache directories"
  preBuild = ''
    export XDG_CACHE_HOME="$(mktemp -d)"
  '';

  meta = with lib; {
    description = "Wayland C++ binding";
    mainProgram = "wayland-scanner++";
    homepage = "https://github.com/NilsBrause/waylandpp/";
    license = with lib.licenses; [
      bsd2
      hpnd
    ];
    maintainers = with lib.maintainers; [ minijackson ];
  };
}
