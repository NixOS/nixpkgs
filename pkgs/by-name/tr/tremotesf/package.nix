{
  stdenv,
  lib,
  cmake,
  pkg-config,
  fetchFromGitHub,
  fmt,
  libpsl,
  cxxopts,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tremotesf";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "equeim";
    repo = "tremotesf2";
    tag = finalAttrs.version;
    hash = "sha256-0nqdCf0rRPEf8O5ZuC2uYLSJavXIDhhiB3sNMryP3Jg=";
    # We need this for src/libtremotesf
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.qtbase
    kdePackages.qttools
    fmt
    libpsl
    kdePackages.kwidgetsaddons
    kdePackages.kwindowsystem
    cxxopts
  ];

  meta = {
    description = "Remote GUI for transmission-daemon";
    mainProgram = "tremotesf";
    license = lib.licenses.gpl3Plus;
    homepage = "https://github.com/equeim/tremotesf2";
    maintainers = with lib.maintainers; [ sochotnicky ];
  };
})
