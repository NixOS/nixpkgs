# This file was generated and will be overwritten by ./generate.sh

{
  stdenv,
  fetchurl,
  lib,
}:

stdenv.mkDerivation {
  pname = "python315-docs-text";
  version = "3.15.1";

  src = fetchurl {
    url = "https://www.python.org/ftp/python/doc/3.15.1/python-3.15.1-docs-text.tar.bz2";
    sha256 = "sha256-3cdWqho0fsBVfSEU6Lq2wG072e4BApWbx5WD2egR7dQ=";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python315
    cp -R ./ $out/share/doc/python315/text
  '';
  meta = {
    maintainers = with lib.maintainers; [
      panicgh
    ];
  };
}
