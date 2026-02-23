{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchurl,
  fetchpatch,
  cmake,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  faudio,
  physfs,
  SDL2,
  tinyxml-2,
  makeAndPlay ? false,
}:

stdenv.mkDerivation rec {
  pname = "vvvvvv";
  version = "2.4.3-unstable-2026-02-16";

  src = fetchFromGitHub {
    owner = "TerryCavanagh";
    repo = "VVVVVV";
    rev = "deeed00c95b82120a92bb3a7e3fb72c5acd1da3a";
    hash = "sha256-NMwVeKuGS7TVK5u0cVCOCML97z056TckhtqhoJgoNs4=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      name = "use-vendored-lodepng.patch"; # Not packaged in nixpkgs atm
      url = "https://github.com/TerryCavanagh/VVVVVV/commit/d9a3158f6a85737bd99a94af765a85798d85671c.patch";
      hash = "sha256-nyLBfhURAr8UGkSKHkdD7WmIVxD7AAldkI7efk0PDBk=";
      revert = true;
    })
  ];

  dataZip = fetchurl {
    url = "https://thelettervsixtim.es/makeandplay/data.zip";
    name = "data.zip";
    hash = "sha256-x2eAlZT2Ry2p9WE252ZX44ZA1YQWSkYRIlCsYpPswOo=";
    meta.license = lib.licenses.unfree;
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    faudio
    physfs
    SDL2
    tinyxml-2
  ];

  cmakeDir = "../desktop_version";

  cmakeFlags = [
    "-DBUNDLE_DEPENDENCIES=OFF"
  ]
  ++ lib.optional makeAndPlay "-DMAKEANDPLAY=ON";

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "VVVVVV";
      desktopName = "VVVVVV";
      comment = meta.description;
      exec = "vvvvvv";
      icon = "VVVVVV";
      terminal = false;
      categories = [ "Game" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 VVVVVV $out/bin/vvvvvv
    install -Dm644 "$src/desktop_version/icon.ico" "$out/share/pixmaps/VVVVVV.png"
    cp -r "$src/desktop_version/fonts/" "$out/share/"
    cp -r "$src/desktop_version/lang/" "$out/share/"

    wrapProgram $out/bin/vvvvvv \
      --add-flags "-assets ${dataZip}" \
      --add-flags "-langdir $out/share/lang" \
      --add-flags "-fontsdir $out/share/fonts"

    runHook postInstall
  '';

  meta = {
    description =
      "A retro-styled platform game"
      + lib.optionalString makeAndPlay " (redistributable, without original levels)";
    longDescription = ''
      VVVVVV is a platform game all about exploring one simple mechanical
      idea - what if you reversed gravity instead of jumping?
    ''
    + lib.optionalString makeAndPlay ''
      (Redistributable version, doesn't include the original levels.)
    '';
    homepage = "https://thelettervsixtim.es";
    changelog = "https://github.com/TerryCavanagh/VVVVVV/releases/tag/${src.rev}";
    license = lib.licenses.unfree;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
