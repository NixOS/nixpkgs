{ stdenv, fetchgit, clang }:

stdenv.mkDerivation rec {
  name = "mujs-2015-01-18";

  src = fetchgit {
    url = git://git.ghostscript.com/mujs.git;
    rev  = "b005928523d2427f8b1daac093c259ab53dba3e9";
    sha256 = "1fgcpa0lm521nbhp7ldh515q0l8012wcfkfyiffchza2wsgmrgfj";
  };

  buildInputs = [ clang ];

  makeFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    homepage = http://mujs.com/;
    description = "A lightweight, embeddable Javascript interpreter";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with maintainers; [ pSub ];
    license = licenses.gpl3;
  };
}
