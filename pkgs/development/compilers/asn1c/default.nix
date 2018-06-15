{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "asn1c-${version}";
  version = "0.9.28";

  src = fetchurl {
    url = "http://lionet.info/soft/asn1c-${version}.tar.gz";
    sha256 = "1fc64g45ykmv73kdndr4zdm4wxhimhrir4rxnygxvwkych5l81w0";
  };

  outputs = [ "out" "doc" "man" ];

  buildInputs = [ perl ];

  preConfigure = ''
    patchShebangs examples/crfc2asn1.pl
  '';

  postInstall = ''
    cp -r skeletons/standard-modules $out/share/asn1c
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://lionet.info/asn1c/compiler.html;
    description = "Open Source ASN.1 Compiler";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = [ maintainers.montag451 ];
  };
}
