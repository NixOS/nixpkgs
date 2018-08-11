{stdenv, fetchFromGitHub, cmake} :

stdenv.mkDerivation {
  name = "boxfort-0.0.1";
  src = fetchFromGitHub {
    owner = "diacritic";
    repo = "BoxFort";
    rev = "4bac60bf13a49eadb76f55343164cbe8199b8d66";
    sha256 = "1y3iywqhplffrmmydplkc9641ndyp7x8wq9h7ap5083s6ff5nk1g";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/diacritic/BoxFort";
    description = "A simple, cross-platform sandboxing C library powering Criterion";
    license = stdenv.lib.licenses.mit;
    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
