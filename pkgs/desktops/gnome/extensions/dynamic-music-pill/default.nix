{
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
  stdenv ? pkgs.stdenv,
  fetchFromGitHub ? pkgs.fetchFromGitHub,
  glib ? pkgs.glib,
  nixosTests ? pkgs.nixosTests,
  ...
}:
stdenv.mkDerivation {
  pname = "gnome-shell-extension-dynamic-music-pill";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Andbal23";
    repo = "dynamic-music-pill";
    rev = "refs/tags/1.0.0";
    hash = "sha256-DIO6qVAfcKY5IAyeKrzhGE6qEXHcr4hb7Viu6MlqpJA=";
  };

  nativeBuildInputs = [ glib ];

  buildPhase = ''
    runHook preBuild
    if [ -d schemas ]; then
      glib-compile-schemas --strict schemas
    fi
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/glib-2.0/schemas/
    if [ -d schemas ] && [ -f schemas/*.gschema.xml ]; then
      glib-compile-schemas --strict schemas
      if [ -f schemas/gschemas.compiled ]; then
        cp schemas/gschemas.compiled $out/share/glib-2.0/schemas/
      fi
      cp schemas/*.gschema.xml $out/share/glib-2.0/schemas/
    fi
    mkdir -p $out/share/gnome-shell/extensions/
    cp -r -T . $out/share/gnome-shell/extensions/dynamic-music-pill@andbal
    runHook postInstall
  '';

  meta = {
    description = "An elegant, pill-shaped music player for your desktop. Features a smooth audio visualizer, scrolling text, and seamless integration with Dash-to-Dock and the Top Panel.";
    longDescription = "An elegant, pill-shaped music player for your desktop. Features a smooth audio visualizer, scrolling text, and seamless integration with Dash-to-Dock and the Top Panel.";
    homepage = "https://github.com/Andbal23/dynamic-music-pill";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };

  passthru = {
    extensionPortalSlug = "dynamic-music-pill";
    extensionUuid = "dynamic-music-pill@andbal";
    tests = {
      gnome-extensions = nixosTests.gnome-extensions;
    };
  };
}
