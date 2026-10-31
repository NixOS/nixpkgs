# This file was generated and will be overwritten by ./generate.sh

{
  stdenv,
  fetchurl,
  lib,
}:

stdenv.mkDerivation {
  pname = "python315-docs-html";
  version = "3.15.2";

  src = fetchurl {
    url = "https://www.python.org/ftp/python/doc/3.15.2/python-3.15.2-docs-html.tar.bz2";
    sha256 = "sha256-zSEVuVmb6GwvYeWHR9aS4jdr2b1DTrhuIzrqaWjcPz4=";
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
