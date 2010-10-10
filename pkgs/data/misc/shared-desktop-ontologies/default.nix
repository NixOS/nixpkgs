{stdenv, fetchurl, cmake}:

stdenv.mkDerivation rec {
  name = "shared-desktop-ontologies-0.5";
  src = fetchurl {
    url = "mirror://sf/oscaf/${name}.tar.bz2";
    sha256 = "1a1gs2b314133rg7vzwvnqbxchf7xgs0jpkydid5l2wz98m7j17r";
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

