{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "redhat-liberation";
  src = fetchurl {
    url = https://fedorahosted.org/releases/l/i/liberation-fonts/liberation-fonts-1.04.tar.gz;
    sha256 = "189i6pc4jqhhmsb9shi8afg9af9crpmz9bnlldhqaxavr1bhj38f";
  };
  
  installPhase = ''
    ensureDir $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';
}
  
