# This file was generated and will be overwritten by ./generate.sh

{
  stdenv,
  fetchurl,
  lib,
}:

stdenv.mkDerivation {
  pname = "python314-docs-texinfo";
  version = "3.14";

  src = fetchurl {
    url = "https://docs.python.org/3.14/archives/python-3.14-docs-texinfo.tar.bz2";
    sha256 = "0r89zg2dzh90iv3qff9rx0ckfsds8hin5z53ai31cchxhglg4b8s";
  };
  installPhase = ''
    mkdir -p $out/share/info
    cp ./python.info $out/share/info
  '';
  meta = {
    maintainers = with lib.maintainers; [
      panicgh
    ];
  };
}
