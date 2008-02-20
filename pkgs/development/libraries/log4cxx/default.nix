args: with args;

stdenv.mkDerivation {
	name = "log4cxx-0.9.7";
	src = fetchurl {
		url = http://archive.apache.org/dist/logging/log4cxx/log4cxx-0.9.7.tar.gz;
		sha256 = "1ikyxd8jgf7b2cqjk5lidl7cffs114iiblaczaqbv5bm4vyb4hav";
	};
	buildInputs = [ autoconf automake libtool libxml2 cppunit boost ];
	patchPhase = "sh autogen.sh; sed -e 's/DOMConfigurator::subst/subst/' -i include/log4cxx/xml/domconfigurator.h";
}
