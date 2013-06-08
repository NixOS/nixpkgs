{ stdenv, fetchurl, which, qt4 }:

stdenv.mkDerivation rec {
  name = "qca-2.0.3";
  
  src = fetchurl {
    url = "http://delta.affinix.com/download/qca/2.0/${name}.tar.bz2";
    sha256 = "0pw9fkjga8vxj465wswxmssxs4wj6zpxxi6kzkf4z5chyf4hr8ld";
  };
  
  buildInputs = [ qt4 ];
  
  nativeBuildInputs = [ which ];

  preBuild =
    ''
      sed -i include/QtCrypto/qca_publickey.h -e '/EMSA3_Raw/a,\
              EMSA3_SHA224,     ///< SHA224, with EMSA3 (ie PKCS#1 Version 1.5) encoding\
              EMSA3_SHA256,     ///< SHA256, with EMSA3 (ie PKCS#1 Version 1.5) encoding\
              EMSA3_SHA384,     ///< SHA384, with EMSA3 (ie PKCS#1 Version 1.5) encoding\
              EMSA3_SHA512      ///< SHA512, with EMSA3 (ie PKCS#1 Version 1.5) encoding'
    '';

  configureFlags = "--no-separate-debug-info";

  enableParallelBuilding = true;
  
  meta = with stdenv.lib; {
    description = "Qt Cryptographic Architecture";
    license = "LGPL";
    homepage = http://delta.affinix.com/qca;
    maintainers = [ maintainers.sander maintainers.urkud ];
  };
}
