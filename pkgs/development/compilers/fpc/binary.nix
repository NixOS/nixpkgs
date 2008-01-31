args: with args;
stdenv.mkDerivation {
  name = "fpc-2.0.4-binary";

  src = fetchurl {
		url = ftp://ftp.chg.ru/pub/lang/pascal/fpc/dist/i386-linux-2.0.4/fpc-2.0.4.i386-linux.tar;
		sha256 = "0b2szv2anbf58h4i5mlph93afv9qdx6i0jqggba04d3anjbl9gfy";
	};

  builder = ./binary-builder.sh;

  meta = {
    description = "
	Free Pascal Compiler from a binary distribution.
";
  };
} 
