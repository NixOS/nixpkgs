{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "comic-neue-1.1";

  src = fetchurl {
    url = "http://comicneue.com/comic-neue-1.1.zip";
    sha256 = "f9442fc42252db62ea788bd0247ae0e74571678d1dbd3e3edc229389050d6923";
  };

  buildInputs = [unzip];
  phases = [ "unpackPhase" "installPhase" ];
  sourceRoot = name;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -v *.ttf $out/share/fonts/truetype
  '';

  meta = with stdenv.lib; {
    homepage = http://comicneue.com/;
    description = "A casual type face: Make your lemonade stand look like a fortune 500 company";
    longDescription = ''
      It is inspired by Comic Sans but more regular.  The font was
      designed by Craig Rozynski.  It is available in two variants:
      Comic Neue and Comic Neue Angular.  The former having round and
      the latter angular terminals.  Both variants come in Light,
      Regular, and Bold weights with Oblique variants.
    '';
    license = licenses.cc0;
    platforms = platforms.all;
  };
}
