{stdenv, fetchurl, cmake, v ? "0.2"}:

stdenv.mkDerivation rec {
  name = "shared-desktop-ontologies-${v}";
  src = fetchurl {
    url = "mirror://sf/oscaf/${name}.tar.bz2";
    sha256 =
      if v == "0.2" then
        "1w9gfprrp518hb7nm5wspxjd7xx0h08bph6asrx5vrx7j7fzg4m7"
      else if v == "0.5" then
        "1a1gs2b314133rg7vzwvnqbxchf7xgs0jpkydid5l2wz98m7j17r"
      else throw "Unknown version";
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

