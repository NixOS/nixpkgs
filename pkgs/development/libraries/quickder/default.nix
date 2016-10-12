{ stdenv, fetchFromGitHub, fetchurl, hexio, python, which, asn2quickder, bash }:

stdenv.mkDerivation rec {
  pname = "quickder";
  name = "${pname}-${version}";
  version = "1.0-RC1";

  src = fetchFromGitHub {
    sha256 = "05gw5dqkw3l8kwwm0044zpxhcp7sxicx9wxbfyr49c91403p870w";
    rev = "version-${version}";
    owner = "vanrein";
    repo = "quick-der";
  };

  buildInputs = [ which asn2quickder bash ];

  patchPhase = ''
    substituteInPlace Makefile \
      --replace 'lib tool test rfc' 'lib test rfc'
    substituteInPlace ./rfc/Makefile \
      --replace 'ASN2QUICKDER_CMD = ' 'ASN2QUICKDER_CMD = ${asn2quickder}/bin/asn2quickder #'
    '';

  installFlags = "ASN2QUICKDER_DIR=${asn2quickder}/bin ASN2QUICKDER_CMD=${asn2quickder}/bin/asn2quickder";
  installPhase = ''
    mkdir -p $out/lib $out/man
    make DESTDIR=$out PREFIX=/ all
    make DESTDIR=$out PREFIX=/ install
    '';

  meta = with stdenv.lib; {
    description = "Quick (and Easy) DER, a Library for parsing ASN.1";
    homepage = https://github.com/vanrein/quick-der;
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ leenaars ];
  };
}
