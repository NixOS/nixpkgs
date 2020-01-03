{ stdenv, fetchgit, makeWrapper, file, libpng, libjpeg }:

stdenv.mkDerivation rec {
  pname = "farbfeld";
  version = "4";

  src = fetchgit {
    url = "https://git.suckless.org/farbfeld";
    rev = "refs/tags/${version}";
    sha256 = "0pkmkvv5ggpzqwqdchd19442x8gh152xy5z1z13ipfznhspsf870";
  };

  buildInputs = [ libpng libjpeg ];
  nativeBuildInputs = [ makeWrapper ];

  installFlags = [ "PREFIX=/" "DESTDIR=$(out)" ];
  postInstall = ''
    wrapProgram "$out/bin/2ff" --prefix PATH : "${file}/bin"
  '';

  meta = with stdenv.lib; {
    description = "Suckless image format with conversion tools";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
