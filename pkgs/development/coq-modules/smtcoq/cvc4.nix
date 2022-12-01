{ lib, stdenv, cln, fetchurl, gmp, swig, pkg-config
, libantlr3c, boost, autoreconfHook
, python3
}:

stdenv.mkDerivation rec {
  pname = "cvc4";
  version = "1.6";

  src = fetchurl {
    url = "https://cvc4.cs.stanford.edu/downloads/builds/src/cvc4-${version}.tar.gz";
    sha256 = "1iw793zsi48q91lxpf8xl8lnvv0jsj4whdad79rakywkm1gbs62w";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ gmp swig libantlr3c boost python3 ]
    ++ lib.optionals stdenv.isLinux [ cln ];

  configureFlags = [
    "--enable-language-bindings=c"
    "--enable-gpl"
    "--with-boost=${boost.dev}"
  ] ++ lib.optionals stdenv.isLinux [ "--with-cln" ];

  prePatch = ''
    patch -p1 -i ${./minisat-fenv.patch} -d src/prop/minisat
    patch -p1 -i ${./minisat-fenv.patch} -d src/prop/bvminisat
  '';

  preConfigure = ''
    patchShebangs ./src/
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A high-performance theorem prover and SMT solver";
    homepage    = "http://cvc4.cs.stanford.edu/web/";
    license     = licenses.gpl3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ vbgl thoughtpolice gebner ];
  };
}
