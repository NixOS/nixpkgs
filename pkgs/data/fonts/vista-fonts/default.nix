{stdenv, fetchurl, cabextract}:

stdenv.mkDerivation {
  name = "vista-fonts-1";
  
  src = fetchurl {
    url = http://download.microsoft.com/download/f/5/a/f5a3df76-d856-4a61-a6bd-722f52a5be26/PowerPointViewer.exe;
    sha256 = "07vhjdw8iip7gxk6wvp4myhvbn9619g10j9qvpbzz4ihima57ry4";
  };

  buildInputs = [cabextract];

  unpackPhase = "
    cabextract --lowercase --filter ppviewer.cab $src
    cabextract --lowercase --filter '*.TTF' ppviewer.cab
    sourceRoot=.
  ";
  
  buildPhase = "true";
  
  installPhase = "
    mkdir -p $out/share/fonts/truetype; cp *.ttf $out/share/fonts/truetype
  ";

  meta = {
    description = "Some TrueType fonts from Microsoft Windows Vista (Calibri, Cambria, Candara, Consolas, Constantia, Corbel)";
    homepage = http://www.microsoft.com/typography/ClearTypeFonts.mspx;
    binaryDistribution = false; # haven't read the EULA, but we probably can't redistribute these files, so...
  };
}
