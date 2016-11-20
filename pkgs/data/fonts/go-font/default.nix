{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "go-font-${version}";
  version = "2016-11-17";

  src = fetchgit {
    url = "https://go.googlesource.com/image";
    rev = "d2f07f8aaaa906f1a64eee0e327fc681cdb2944f";
    sha256 = "1kmsipa4cyrwx86acc695c281hchrz9k9ni8r7giyggvdi577iga";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    mkdir -p $out/share/doc/go-font
    cp font/gofont/ttfs/* $out/share/fonts/truetype
    mv $out/share/fonts/truetype/README $out/share/doc/go-font/LICENSE
  '';

  meta = with stdenv.lib; {
    homepage = https://blog.golang.org/go-fonts;
    description = "The Go font family";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sternenseemann ];
    platforms = stdenv.lib.platforms.all;
    hydraPlatforms = [];
  };
}
