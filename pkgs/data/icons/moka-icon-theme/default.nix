{ stdenv, fetchFromGitHub, autoreconfHook, faba-icon-theme }:

stdenv.mkDerivation rec {
  name = "${package-name}-${version}";
  package-name = "moka-icon-theme";
  version = "2017-02-13";

  src = fetchFromGitHub {
    owner = "snwh";
    repo = package-name;
    rev = "5ac530d2394574bdbd5360de46391d0dfc7aa2ab";
    sha256 = "1zw1jm03706086gnplkkrdlrcyhgwm9kp4qax57wwc1s27bhc90n";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ faba-icon-theme ];

  postPatch = ''
    substituteInPlace Makefile.am --replace '$(DESTDIR)'/usr $out
  '';

  meta = with stdenv.lib; {
    description = "An icon theme designed with a minimal flat style using simple geometry and bright colours";
    homepage = https://snwh.org/moka;
    license = with licenses; [ cc-by-sa-40 gpl3 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ romildo ];
  };
}
