# This file was generated and will be overwritten by ./generate.sh

{
  stdenv,
  fetchurl,
  lib,
}:

stdenv.mkDerivation {
  pname = "python315-docs-html";
  version = "3.15.1";

  src = fetchurl {
    url = "https://www.python.org/ftp/python/doc/3.15.1/python-3.15.1-docs-html.tar.bz2";
    sha256 = "sha256-ni1iRohFopk0ocM5JP0XQgs730I38ipn5URq7Rd1Ga4=";
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
