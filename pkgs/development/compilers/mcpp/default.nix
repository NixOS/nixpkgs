{ lib, stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "mcpp";
  version = "2.7.2";

  src = fetchurl {
    url = "mirror://sourceforge/mcpp/mcpp-${version}.tar.gz";
    sha256 = "0r48rfghjm90pkdyr4khxg783g9v98rdx2n69xn8f6c5i0hl96rv";
  };

  configureFlags = [ "--enable-mcpplib" ];

  patches = [
    (fetchpatch {
      name = "CVE-2019-14274.patch";
      url = "https://github.com/h8liu/mcpp/commit/ea453aca2742be6ac43ba4ce0da6f938a7e5a5d8.patch";
      sha256 = "0svkdr3w9b45v6scgzvggw9nsh6a3k7g19fqk0w3vlckwmk5ydzr";
    })
  ];

  meta = with lib; {
    homepage = "http://mcpp.sourceforge.net/";
    description = "A portable c preprocessor";
    license = licenses.bsd2;
    platforms = platforms.unix;
  };
}
