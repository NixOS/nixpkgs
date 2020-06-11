{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "erfa";
  version = "1.7.0";

  buildInputs = [ autoreconfHook ];

  src = fetchFromGitHub {
    owner = "liberfa";
    repo = "erfa";
    rev = "v${version}";
    sha256 = "1z4k2phrw6wwi0kax6ac80jk9c036gi7pmhmg6gaf3lk81k6xz2r";
  };

  configureFlags = [ "--enable-shared" ];

  meta = with stdenv.lib; {
    description = "Essential Routines for Fundamental Astronomy";
    homepage = "https://github.com/liberfa/erfa";
    maintainers = with maintainers; [ mir06 ];
    license = {
      url = "https://github.com/liberfa/erfa/blob/master/LICENSE";
      free = true;
    };
  };
}
