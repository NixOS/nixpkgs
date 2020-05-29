{ stdenv
, fetchurl
, shen-sources
, sbcl
}:

stdenv.mkDerivation rec {
  name = "shen-sbcl-${version}";
  version = "3.0.3";
  src = fetchurl {
    url = "https://github.com/Shen-Language/shen-cl/releases/download/v${version}/shen-cl-v${version}-sources.tar.gz";
    sha256 = "0mc10jlrxqi337m6ngwbr547zi4qgk69g1flz5dsddjy5x41j0yz";
  };
  buildInputs = [
    sbcl shen-sources
  ];
  buildPhase = ''
    ln -s ${shen-sources} kernel
    make sbcl
  '';
  installPhase = ''
    mkdir -p $out
    install -m755 -D bin/sbcl/shen $out/bin/shen-sbcl
  '';
  meta = with stdenv.lib; {
    homepage = https://shenlanguage.org;
    description = "Port of Shen running on Steel Bank Common Lisp";
    platforms = sbcl.meta.platforms;
    maintainers = with maintainers; [ bsima ];
    license = licenses.bsd3;
  };
}
