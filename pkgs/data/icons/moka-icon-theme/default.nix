{ stdenv, fetchFromGitHub, autoreconfHook, faba-icon-theme }:

stdenv.mkDerivation rec {
  name = "${package-name}-${version}";
  package-name = "moka-icon-theme";
  version = "2016-10-06";

  src = fetchFromGitHub {
    owner = "snwh";
    repo = package-name;
    rev = "50894ee9411721649019cd168b8ae2c85f4b5cf0";
    sha256 = "1dlpsgqsn731ra5drkx72wljcgv1zydgldy4nn5bbia9s5w8mfgs";
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
