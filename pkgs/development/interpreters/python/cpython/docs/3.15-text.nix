# This file was generated and will be overwritten by ./generate.sh

{
  stdenv,
  fetchurl,
  lib,
}:

stdenv.mkDerivation {
  pname = "python315-docs-text";
  version = "3.15.2";

  src = fetchurl {
    url = "https://www.python.org/ftp/python/doc/3.15.2/python-3.15.2-docs-text.tar.bz2";
    sha256 = "sha256-sh2VFTSRz4AffVhCTrf5uJ3Jb2Os41zp+0imoGGpNNQ=";
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
