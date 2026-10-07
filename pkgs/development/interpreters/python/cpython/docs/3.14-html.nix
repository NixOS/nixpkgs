# This file was generated and will be overwritten by ./generate.sh

{
  stdenv,
  fetchurl,
  lib,
}:

stdenv.mkDerivation {
  pname = "python314-docs-html";
  version = "3.14.8";

  src = fetchurl {
    url = "https://www.python.org/ftp/python/doc/3.14.8/python-3.14.8-docs-html.tar.bz2";
    sha256 = "sha256-+6/XHOClP7P9hMtWq2YOgTh6iGvT+tqJhkekN7lCxT0=";
  };
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/doc/python314
    cp -R ./ $out/share/doc/python314/html
    runHook postInstall
  '';
  meta = {
    maintainers = with lib.maintainers; [
      panicgh
    ];
  };
}
