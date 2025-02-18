{
  lib,
  stdenv,
  fetchurl,
  wget,
  bash,
}:

stdenv.mkDerivation rec {
  pname = "wgetpaste";
  version = "2.34";

  src = fetchurl {
    url = "https://github.com/zlin/wgetpaste/releases/download/${version}/wgetpaste-${version}.tar.xz";
    sha256 = "sha256-vW0G7ZAaPWPJyMVxJghP8JlPCZAb+xY4uHlT6sHpQz8=";
  };
  # currently zsh-autocompletion support is not installed

  prePatch = ''
    substituteInPlace wgetpaste --replace "/usr/bin/env bash" "${bash}/bin/bash"
    substituteInPlace wgetpaste --replace "LC_ALL=C wget" "LC_ALL=C ${wget}/bin/wget"
  '';

  installPhase = ''
    mkdir -p $out/bin;
    cp wgetpaste $out/bin;
  '';

  meta = {
    description = "Command-line interface to various pastebins";
    mainProgram = "wgetpaste";
    homepage = "https://github.com/zlin/wgetpaste";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [
      qknight
      domenkozar
    ];
    platforms = lib.platforms.all;
  };
}
