{stdenv, fetchurl, which, qt4}:

stdenv.mkDerivation {
  name = "qca-2.0.2";
  src = fetchurl {
    url = http://delta.affinix.com/download/qca/2.0/qca-2.0.2.tar.bz2;
    sha256 = "49b5474450104a2298747c243de1451ab7a6aeed4bf7df43ffa4b7128a2837b8";
  };
  buildInputs = [ which qt4 ];
  preBuild = ''
    sed -i include/QtCrypto/qca_publickey.h -e '/EMSA3_Raw/a,\
            EMSA3_SHA224,     ///< SHA224, with EMSA3 (ie PKCS#1 Version 1.5) encoding\
            EMSA3_SHA256,     ///< SHA256, with EMSA3 (ie PKCS#1 Version 1.5) encoding\
            EMSA3_SHA384,     ///< SHA384, with EMSA3 (ie PKCS#1 Version 1.5) encoding\
            EMSA3_SHA512      ///< SHA512, with EMSA3 (ie PKCS#1 Version 1.5) encoding'
  '';
  meta = with stdenv.lib; {
    description = "Qt Cryptographic Architecture";
    license = "LGPL";
    homepage = http://delta.affinix.com/qca;
    maintainers = [ maintainers.sander maintainers.urkud ];
  };
}
