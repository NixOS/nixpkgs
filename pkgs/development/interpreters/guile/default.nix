args: with args; 
stdenv.mkDerivation {
  name = "guile-1.6.7";
  src = fetchurl {
		url = ftp://ftp.gnu.org/gnu/guile/guile-1.8.2.tar.gz;
		sha256 = "03kn1ia4s7l24zl2sfbrns6fs3nc9cw2pzsqx8y7wwr80b1nfxhz";
	};

  propagatedBuildInputs = [readline libtool gmp];
}
