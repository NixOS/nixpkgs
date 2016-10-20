{ stdenv, fetchFromGitHub, autoreconfHook, elementary-icon-theme }:

stdenv.mkDerivation rec {
  name = "${package-name}-${version}";
  package-name = "faba-icon-theme";
  version = "2016-09-13";

  src = fetchFromGitHub {
    owner = "moka-project";
    repo = package-name;
    rev = "00431894bce5fb1b8caccaee064788996be228a7";
    sha256 = "0hif030pd4w3s851k0s65w0mf2pik10ha25ycpsv91gpbgarqcns";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ elementary-icon-theme ];

  postPatch = ''
    substituteInPlace Makefile.am --replace '$(DESTDIR)'/usr $out
  '';

  meta = with stdenv.lib; {
    description = "A sexy and modern icon theme with Tango influences";
    homepage = https://snwh.org/moka;
    license = with licenses; [ cc-by-sa-40 gpl3 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ romildo ];
  };
}
