{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  name = "shared-desktop-ontologies-0.8.0";
  
  src = fetchurl {
    url = "mirror://sourceforge/oscaf/${name}.tar.bz2";
    sha256 = "0wf4gli2akkqbl944lqjjy2hvcfagq6zzmdg7fkzr61p6vw7nk82";
  };
  
  buildInputs = [ cmake ];
  
  meta = with stdenv.lib; {
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

