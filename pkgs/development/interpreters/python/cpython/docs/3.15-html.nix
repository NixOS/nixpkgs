# This file was generated and will be overwritten by ./generate.sh

{
  stdenv,
  fetchurl,
  lib,
}:

stdenv.mkDerivation {
  pname = "python315-docs-html";
  version = "3.15.0";

  src = fetchurl {
    url = "https://www.python.org/ftp/python/doc/3.15.0/python-3.15.0-docs-html.tar.bz2";
    sha256 = "sha256-jJE8LrZaFEQCw/aS3h/LDMeebauP+W9ASIBIbHUnfIQ=";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python315
    cp -R ./ $out/share/doc/python315/html
  '';
  meta = {
    maintainers = with lib.maintainers; [
      panicgh
    ];
  };
}
