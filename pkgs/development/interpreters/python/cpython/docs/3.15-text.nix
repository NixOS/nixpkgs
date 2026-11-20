# This file was generated and will be overwritten by ./generate.sh

{
  stdenv,
  fetchurl,
  lib,
}:

stdenv.mkDerivation {
  pname = "python315-docs-text";
  version = "3.15.0";

  src = fetchurl {
    url = "https://www.python.org/ftp/python/doc/3.15.0/python-3.15.0-docs-text.tar.bz2";
    sha256 = "sha256-sr6guluV3vr7VXq4QKQn/xntrGaJZFzfI27G1ubSAPY=";
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
