# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  name = "python30-docs-html-3.0.1";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/3.0.1/python-3.0.1-docs-html.tar.bz2;
    sha256 = "0ybjnhg8qfr9kc4axm5xlghkz9dmsg6b1caj6m4gz28q89vggv3c";
  };
  installPhase = ''
    mkdir -p $out/share/doc
    cp -R ./ $out/share/doc/${name}
  '';
  meta = {
    maintainers = [ lib.maintainers.chaoflow ];
  };
}
