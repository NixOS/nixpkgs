{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  name = "shared-desktop-ontologies-0.10.0";
  
  src = fetchurl {
    url = "mirror://sourceforge/oscaf/${name}.tar.bz2";
    sha256 = "00y55bjmxrwiiw8q0n0jcv95l945hp7nglbwj408sk5m2vq026di";
  };
  
  buildInputs = [ cmake ];
  
  meta = with stdenv.lib; {
    homepage = http://oscaf.sourceforge.net/;
    description = "Ontologies necessary for the Nepomuk semantic desktop";
    longDescription = ''
      The shared-desktop-ontologies package brings the semantic web to the
      desktop in terms of vocabulary. It contains the well known core
      ontologies such as RDF and RDFS as well as the Nepomuk ontologies which
      are used by projects like KDE or Strigi.
    '';
    platforms = platforms.all;
    maintainers = [ maintainers.sander maintainers.urkud ];
  };
}

