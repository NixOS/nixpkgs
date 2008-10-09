args: with args;
stdenv.mkDerivation rec {
	name = "gamin-0.1.9";

	src = fetchurl {
		url = "http://www.gnome.org/~veillard/gamin/sources/${name}.tar.gz";
		sha256 = "0fgjfyr0nlkpdxj94a4qfm82wypljdyv1b6l56v7i9jdx0hcdqhr";
	};

	buildInputs = [python pkgconfig glib];
	configureFlags = "--enable-shared --disable-static --disable-debug --with-python=${python}";
}
