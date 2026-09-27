{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  zlib,
  libpng,
  boron,
  libGL,
  libx11,
  libxcursor,
  faun,
}:

stdenv.mkDerivation rec {
  pname = "xu4";
  version = "1.4.3";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "xu4-engine";
    repo = "u4";
    tag = "v${version}";
    hash = "sha256-0nTnUX2Exka7ytZnFWsjuMIodU4HQ2l/h+z2v550sTU=";
    fetchSubmodules = true;
  };

  # this is not a standard Autotools-like `configure` script
  dontAddPrefix = true;

  preConfigure = ''
    patchShebangs configure
  '';

  postConfigure = ''
    # need to report this upstream
    substituteInPlace src/Makefile \
      --replace-fail "-Wall" "-Wall -Wno-error=format-security"

    # disable git submodule init as part of build
    sed --in-place 's/^\s*git submodule.*//g' src/Makefile.common

    # set binary version (ref https://github.com/NixOS/nixpkgs/commit/571e02812f5da12fd851557ebbacea72fc7b5121#r129407907 )
    substituteInPlace src/Makefile.common \
      --replace-fail "DR-1.0" "${version}"
  '';

  enableParallelBuilding = true;

  buildInputs = [
    zlib
    libpng
    libGL
    libx11
    libxcursor
    faun
    boron
  ];

  nativeBuildInputs = [
    makeWrapper
    boron
  ];

  # The `install` target references some files with unknown license
  installPhase = ''
    install -D -m 555 src/xu4 $out/libexec/xu4
    install -D -m 444 Ultima-IV.mod $out/share/Ultima-IV.mod
    install -D -m 444 U4-Upgrade.mod $out/share/U4-Upgrade.mod
    install -D -m 444 render.pak $out/share/render.pak
    install -D -m 444 icons/xu4.png $out/share/icons/hicolor/48x48/apps/xu4.png
    install -D -m 444 dist/xu4.desktop $out/share/applications/xu4.desktop
    makeWrapper $out/libexec/xu4 $out/bin/xu4 --chdir $out/share
  '';

  meta = {
    homepage = "https://xu4.sourceforge.net/";
    description = "Remake of the computer game Ultima IV";
    license = lib.licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ mausch ];
  };
}
