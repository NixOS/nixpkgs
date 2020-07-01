{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "scheme-manpages-unstable";
  version = "2020-05-17";

  src = fetchFromGitHub {
    owner = "schemedoc";
    repo = "scheme-manpages";
    rev = "e97bd240d398e4e5ffc62305e506a2f2428322a4";
    sha256 = "0c0n3mvghm9c2id8rxfd829plb64nf57jkqgmxf83w7x9jczbqqb";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/man
    cp -r man3/ man7/ $out/share/man/
  '';

  meta = with stdenv.lib; {
    description = "Manpages for Scheme";
    homepage = "https://github.com/schemedoc/scheme-manpages";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
