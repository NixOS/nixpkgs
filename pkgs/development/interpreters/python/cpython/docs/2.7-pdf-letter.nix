# This file was generated and will be overwritten by ./generate.sh

{
  stdenv,
  lib,
  fetchurl,
}:

stdenv.mkDerivation {
  pname = "python27-docs-pdf-letter";
  version = "2.7.18";

  src = fetchurl {
    url = "http://www.python.org/ftp/python/doc/2.7.18/python-2.7.18-docs-pdf-letter.tar.bz2";
    sha256 = "07hbqvrdlq01cb95r1574bxqqhiqbkj4f92wzlq4d6dq1l272nan";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python27
    cp -R ./ $out/share/doc/python27/pdf-letter
  '';
  meta = {
    maintainers = [ ];
  };
}
