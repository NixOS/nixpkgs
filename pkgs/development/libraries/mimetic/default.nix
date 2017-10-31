{ stdenv, fetchurl, cutee }:

stdenv.mkDerivation rec {
  pname = "mimetic";
  version = "0.9.8";
  name = "${pname}-${version}";

  src = fetchurl {
    url    = "http://www.codesink.org/download/${pname}-${version}.tar.gz";
    sha256 = "003715lvj4nx23arn1s9ss6hgc2yblkwfy5h94li6pjz2a6xc1rs";
  };

  buildInputs = [ cutee ];

  meta = with stdenv.lib; {
    description = "MIME handling library";
    homepage    = http://codesink.org/mimetic_mime_library.html;
    license     = licenses.mit;
    maintainers = with maintainers; [ leenaars];
    platforms = platforms.linux;
  };
}
