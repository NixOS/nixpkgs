{ stdenv, fetchgit, clang }:

stdenv.mkDerivation rec {
  name = "mujs-2014-11-29";

  src = fetchgit {
    url = git://git.ghostscript.com/mujs.git;
    rev  = "6afabf445cad0dd9afbc1f5870dba730801f09c0";
    sha256 = "1afzmncw3jvfq6smhhhsi1ywfmdpxkjpzswb86pdmdh3p04g1r0n";
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
