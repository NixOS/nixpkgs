{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "tt-rss-plugin-freshapi";
  version = "0-unstable-2024-11-14";

  src = fetchFromGitHub {
    owner = "eric-pierce";
    repo = "freshapi";
    rev = "44c98f12e8a4423501fc6d8cb7903cca11094dc6";
    hash = "sha256-1cQ4QMrXOdtelAbmMEuhWJPFi5XrAoR3IGlFzb8122k=";
  };

  installPhase = ''
    runHook preInstall

    install -D init.php $out/freshapi/init.php
    install -D api/greader.php $out/freshapi/api/greader.php
    install -D api/freshapi.php $out/freshapi/api/freshapi.php

    runHook postInstall
  '';

  meta = {
    description = "FreshRSS / Google Reader API Plugin for Tiny-Tiny RSS";
    license = lib.licenses.agpl3Only;
    homepage = "https://github.com/eric-pierce/freshapi";
    maintainers = with lib.maintainers; [ wrvsrx ];
    platforms = lib.platforms.all;
  };
}
