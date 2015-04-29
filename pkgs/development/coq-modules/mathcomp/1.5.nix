{stdenv, fetchurl, coq, ssreflect}:

stdenv.mkDerivation {

  name = "coq-mathcomp-1.5-8.5b2";

  src = fetchurl {
    url = http://ssr.msr-inria.inria.fr/FTP/mathcomp-1.5.coq85beta2.tar.gz;
    sha256 = "03bnq44ym43x8shi7whc02l0g5vy6rx8f1imjw478chlgwcxazqy";
  };

  propagatedBuildInputs = [ coq ssreflect ];

  enableParallelBuilding = true;

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = with stdenv.lib; {
    homepage = http://ssr.msr-inria.inria.fr/;
    license = licenses.cecill-b;
    maintainers = [ maintainers.vbgl maintainers.jwiegley ];
    platforms = coq.meta.platforms;
    hydraPlatforms = [];
  };

}
