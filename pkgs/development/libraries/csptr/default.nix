{stdenv, fetchFromGitHub, cmake} :

stdenv.mkDerivation {
  name = "csptr-2.0.4";
  src = fetchFromGitHub {
    owner = "Snaipe";
    repo = "libcsptr";
    rev = "82d3b1beafe7ed9f13f75e0d3367c60205e10f27";
    sha256 = "0i1498h2i6zq3fn3zf3iw7glv6brn597165hnibgwccqa8sh3ich";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/Snaipe/libcsptr";
    description = "This project is an attempt to bring smart pointer constructs to the (GNU) C programming language";
    license = stdenv.lib.licenses.mit;
    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
