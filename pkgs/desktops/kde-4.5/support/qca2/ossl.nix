{stdenv, fetchurl, qt4, qca2, openssl}:

stdenv.mkDerivation rec {
  name = "qca-ossl-2.0.0-beta3";
  src = fetchurl {
    url = "http://delta.affinix.com/download/qca/2.0/plugins/${name}.tar.bz2";
    sha256 = "0yy68racvx3clybry2i1bw5bz9yhxr40p3xqagxxb15ihvsrzq08";
  };
  buildInputs = [ qt4 qca2 openssl ];
  dontAddPrefix = true;
  configureFlags="--no-separate-debug-info --with-qca=${qca2}
    --with-openssl-inc=${openssl}/include --with-openssl-lib=${openssl}/lib";
  preConfigure=''
    configureFlags="$configureFlags --plugins-path=$out/lib/qt4/plugins"
  '';
  patches = [ ./ossl-remove-whirlpool.patch ];
  meta = with stdenv.lib; {
    description = "Qt Cryptographic Architecture OpenSSL plugin";
    license = "LGPL";
    homepage = http://delta.affinix.com/qca;
    maintainers = [ maintainers.urkud ];
  };
}
