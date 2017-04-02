{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "${package-name}-${version}";
  package-name = "paper-icon-theme";
  version = "2017-02-13";

  src = fetchFromGitHub {
    owner = "snwh";
    repo = package-name;
    rev = "fcaf8bb2aacdd1bb7dcde3d45ef92d0751567e8e";
    sha256 = "1l1w99411jrv4l7jr5dvwszghrncsir23c7lpc26gh2f0ydf3d0d";
  };

  nativeBuildInputs = [ autoreconfHook ];

  postPatch = ''
    substituteInPlace Makefile.am --replace '$(DESTDIR)'/usr $out
  '';

  meta = with stdenv.lib; {
    description = "Modern icon theme designed around bold colours and simple geometric shapes";
    homepage = http://snwh.org/paper;
    license = with licenses; [ cc-by-sa-40 lgpl3 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ romildo ];
  };
}
