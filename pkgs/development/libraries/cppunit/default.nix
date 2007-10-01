args: with args;

stdenv.mkDerivation {
	name = "cppunit-1.12.0";
	src = fetchurl {
		url = mirror://sf/cppunit/cppunit-1.12.0.tar.gz;
		sha256 = "07zyyx5dyai94y8r8va28971f5mw84mb93xx9pm6m4ddpj6c79cq";
	};
	configureFlags = "--enable-shared --disable-static";
}
