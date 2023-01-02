{ lib
, stdenv
, fetchurl
, libopcodes
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lightning";
  version = "2.2.0";

  src = fetchurl {
    url = "mirror://gnu/lightning/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    hash = "sha256-TjmE/xzPC6MKmFIR1A/FwGsl8BTr3z2A0P49DIDdfA4=";
  };

  checkInputs = [ libopcodes ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://www.gnu.org/software/lightning/";
    description = "Run-time code generation library";
    longDescription = ''
      GNU lightning is a library that generates assembly language code at
      run-time; it is very fast, making it ideal for Just-In-Time compilers, and
      it abstracts over the target CPU, as it exposes to the clients a
      standardized RISC instruction set inspired by the MIPS and SPARC chips.
    '';
    maintainers = with maintainers; [ AndersonTorres ];
    license = licenses.lgpl3Plus;
    platforms = platforms.unix;
    broken = stdenv.isDarwin; # failing tests
  };
})
