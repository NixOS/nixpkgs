args: with args;
stdenv.mkDerivation {
	name = "cfitsio-3.060";
	src = fetchurl {
		url = ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/cfitsio3060.tar.gz;
		sha256 = "0ijbjpl5v35m538sa3c82qgja697kddjbj7yxx64ka7pdsdnfx9l";
	};
# Shared-only build
	buildFlags = "shared";
	patchPhase = ''
	sed -e '/^install:/s/libcfitsio.a //' -e 's@/bin/@@g' -i Makefile.in
	'';
}
