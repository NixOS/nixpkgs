args: with args;
stdenv.mkDerivation {
	name = "openbabel-2.1.1";
	src = fetchurl { 
		url = mirror://sf/openbabel/openbabel-2.1.1.tar.gz;
		sha256 = "1rgvci796a7bmc49ih26ma7c248d32w6drs3cwljpjk0dllsqdif";
	};
# TODO : perl & python bindings;
# TODO : wxGTK: I have no time to compile
# TODO : separate lib and apps
	buildInputs = [zlib libxml2];
	configureFlags = "--enable-shared --disable-static";
}
