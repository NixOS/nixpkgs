{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  libftdi1,
  libusb1,
  pkg-config,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unfloader";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "buu342";
    repo = "N64-UNFLoader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nps1xhp/gLJspMr1cua7wvD9PoXte/fB8XJB7559D+k=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    ncurses
    libftdi1
    libusb1
  ];

  # Patch the Makefile to use dynamic libraries instead of static ones
  preBuild = ''
    export NIX_LDFLAGS="-lusb-1.0 -lftdi1 $NIX_LDFLAGS"

    # Create symlinks with the static library names pointing to the shared libraries
    mkdir -p staticlibs
    ln -sf ${libusb1}/lib/libusb-1.0.so staticlibs/libusb-1.0.a
    ln -sf ${libftdi1}/lib/libftdi1.so staticlibs/libftdi1.a
    export LIBRARY_PATH=$LIBRARY_PATH:$(pwd)/staticlibs
  '';
  sourceRoot = "${finalAttrs.src.name}/UNFLoader";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -D -m 0755 UNFLoader $out/bin/${finalAttrs.pname}

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };
  meta = {
    description = "USB ROM uploader and debug manager for N64 flashcarts";
    longDescription = ''
      UNFLoader is a tool that allows you to upload ROM files, debug applications,
      and view and modify your device's memory in real time. It provides an interface
      for communication between your PC and the N64 flashcart devices.
    '';
    homepage = "https://github.com/buu342/N64-UNFLoader";
    license = lib.licenses.wtfpl;
    maintainers = [ lib.maintainers.mmarsalko ];
    platforms = lib.platforms.linux;
    mainProgram = "UNFLoader";
  };
})
