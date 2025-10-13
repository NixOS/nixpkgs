{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlr-protocols,
  libGL,
  libgbm,
  bash,
  installExampleScripts ? true,
  makeWrapper,
  installShellFiles,
  pipectl,
  slurp,
  rofi,
  scdoc,
}:

let
  wl-present-binpath = lib.makeBinPath [
    pipectl
    rofi
    slurp
    (placeholder "out")
  ];
in

stdenv.mkDerivation rec {
  pname = "wl-mirror";
  version = "0.18.3";

  src = fetchFromGitHub {
    owner = "Ferdi265";
    repo = "wl-mirror";
    rev = "v${version}";
    hash = "sha256-xj+CZPHeMAisOMB8mYSIc2jAa5iQD5pM+Stccq4gnak=";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
    scdoc
    makeWrapper
    installShellFiles
  ];
  buildInputs = [
    libGL
    libgbm
    wayland
    wayland-protocols
    wlr-protocols
    bash
  ];

  postPatch = ''
    echo 'v${version}' > version.txt
    substituteInPlace CMakeLists.txt \
      --replace 'WL_PROTOCOL_DIR "/usr' 'WL_PROTOCOL_DIR "${wayland-protocols}' \
      --replace 'WLR_PROTOCOL_DIR "/usr' 'WLR_PROTOCOL_DIR "${wlr-protocols}'
  '';

  cmakeFlags = [
    "-DINSTALL_EXAMPLE_SCRIPTS=${if installExampleScripts then "ON" else "OFF"}"
    "-DINSTALL_DOCUMENTATION=ON"
    "-DWITH_GBM=ON"
  ];

  postInstall = ''
    installShellCompletion --cmd wl-mirror \
      --bash ../scripts/completions/bash-completions/_wl-mirror \
      --zsh ../scripts/completions/zsh-completions/_wl-mirror

    installShellCompletion --cmd wl-present \
      --bash ../scripts/completions/bash-completions/_wl-present \
      --zsh ../scripts/completions/zsh-completions/_wl-present
  ''
  + lib.optionalString installExampleScripts ''
    wrapProgram $out/bin/wl-present --prefix PATH ":" ${wl-present-binpath}
  '';

  meta = with lib; {
    homepage = "https://github.com/Ferdi265/wl-mirror";
    description = "Simple Wayland output mirror client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ synthetica ];
    platforms = platforms.linux;
  };
}
