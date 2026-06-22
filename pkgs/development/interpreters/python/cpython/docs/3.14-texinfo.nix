# This file was generated and will be overwritten by ./generate.sh

{
  stdenv,
  fetchurl,
  lib,
}:

stdenv.mkDerivation {
  pname = "python314-docs-texinfo";
  version = "3.14.6";

  src = fetchurl {
    url = "https://www.python.org/ftp/python/doc/3.14.6/python-3.14.6-docs-texinfo.tar.bz2";
    sha256 = "0nwdvgnxs6sik0d1kkl6fnnhxrvmj356i92abp84i33d4dy6i9hw";
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
