# This file was generated and will be overwritten by ./generate.sh

{
  stdenv,
  fetchurl,
  lib,
}:

stdenv.mkDerivation {
  pname = "python314-docs-text";
  version = "3.14.6";

  src = fetchurl {
    url = "https://www.python.org/ftp/python/doc/3.14.6/python-3.14.6-docs-text.tar.bz2";
    sha256 = "0flqq4k9fq948gb3zim04znyxr21pfv8i4mrhh3qwna13fh897zg";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python314
    cp -R ./ $out/share/doc/python314/text
  '';
  meta = {
    maintainers = with lib.maintainers; [
      panicgh
    ];
  };
}
