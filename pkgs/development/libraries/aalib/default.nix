{stdenv, fetchurl, ncurses, automake}:

stdenv.mkDerivation {
  name = "aalib-1.4rc4";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/aa-project/aalib-1.4rc4.tar.gz;
    md5 = "d5aa8e9eae07b7441298b5c30490f6a6";
  };

  # The fuloong2f is not supported by aalib still
  preConfigure = ''
    cp ${automake}/share/automake*/config.{sub,guess} .
  '';

  buildInputs = [ncurses];
  inherit ncurses;

  meta = {
    description = "ASCII art graphics library";
  };
}
