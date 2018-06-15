{ stdenv, fetchgit, clang }:

stdenv.mkDerivation rec {
  name = "mujs-2017-01-24";

  src = fetchgit {
    url = git://git.ghostscript.com/mujs.git;
    rev  = "4006739a28367c708dea19aeb19b8a1a9326ce08";
    sha256 = "0wvjl8lkh0ga6fkmxgjqq77yagncbv1bdy6hpnxq31x3mkwn1s51";
  };

  buildInputs = [ clang ];

  makeFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    homepage = http://mujs.com/;
    description = "A lightweight, embeddable Javascript interpreter";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with maintainers; [ pSub ];
    license = licenses.gpl3;
  };
}
