{ stdenv, fetchFromGitHub, autoreconfHook, faba-icon-theme }:

stdenv.mkDerivation rec {
  name = "${package-name}-${version}";
  package-name = "moka-icon-theme";
  version = "2016-06-07";

  src = fetchFromGitHub {
    owner = "moka-project";
    repo = package-name;
    rev = "a03d14e30dbdf05e8ea904994b8081ad0824e155";
    sha256 = "1j1cnrrg0gfr4vfzxlabrv8090fg4yni99g61s82vnyszkiy1rcm";
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
