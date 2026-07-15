# This file was generated and will be overwritten by ./generate.sh

{
  stdenv,
  fetchurl,
  lib,
}:

stdenv.mkDerivation {
  pname = "python314-docs-html";
  version = "3.14.6";

  src = fetchurl {
    url = "https://www.python.org/ftp/python/doc/3.14.6/python-3.14.6-docs-html.tar.bz2";
    sha256 = "0hm49y5di6zxka8425q6ksw2psfzcn9mmgjq2k5x86w3x47k0jrh";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python314
    cp -R ./ $out/share/doc/python314/html
  '';
  meta = {
    maintainers = with lib.maintainers; [
      panicgh
    ];
  };
}
