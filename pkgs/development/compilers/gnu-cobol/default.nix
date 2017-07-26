{ stdenv, fetchurl, gcc, makeWrapper
, db, gmp, ncurses }:

let version = {
  maj = "2.0";
  min = "rc-2";
};
in 
stdenv.mkDerivation rec {
  name = "gnu-cobol-${version.maj}${version.min}";

  src = fetchurl {
    url = "https://sourceforge.com/projects/open-cobol/files/gnu-cobol/${version.maj}/gnu-cobol-${version.maj}_${version.min}.tar.gz";
    sha256 = "1pj7mjnp3l76zvzrh1xa6d4kw3jkvzqh39sbf02kiinq4y65s7zj";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ db gmp ncurses ];

  postInstall = with stdenv.lib; ''
    wrapProgram "$out/bin/cobc" \
      --prefix PATH ':' "${gcc}/bin" \
      --prefix NIX_LDFLAGS ' ' "'$NIX_LDFLAGS'" \
      --prefix NIX_CFLAGS_COMPILE ' ' "'$NIX_CFLAGS_COMPILE'"
  '';

  meta = with stdenv.lib; {
    description = "An open-source COBOL compiler";
    homepage = http://sourceforge.net/projects/open-cobol/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ ericsagnes ];
    platforms = platforms.linux;
  };
}
