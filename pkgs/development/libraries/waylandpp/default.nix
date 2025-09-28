{
  lib,
  stdenv,
  fetchFromGitHub,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "waylandpp";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "NilsBrause";
    repo = "waylandpp";
    tag = finalAttrs.version;
    hash = "sha256-vKYKUXq5lmjQcZ0rD+b2O7N1iCVnpkpKd8Z/RTI083g=";
  };

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INSTALL_DATADIR" (placeholder "dev"))
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    (lib.cmakeFeature "WAYLAND_SCANNERPP" "${buildPackages.waylandpp}/bin/wayland-scanner++")
  ];

  # Complains about not being able to find the fontconfig config file otherwise
  FONTCONFIG_FILE = lib.optional docSupport (makeFontsConf {
    fontDirectories = [ ];
  });

  nativeBuildInputs = [
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

  outputs = [
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

  meta = {
    description = "Wayland C++ binding";
    mainProgram = "wayland-scanner++";
    homepage = "https://github.com/NilsBrause/waylandpp/";
    license = with lib.licenses; [
      bsd2
      hpnd
    ];
    maintainers = with lib.maintainers; [ minijackson ];
    platforms = lib.platforms.linux;
  };
})
