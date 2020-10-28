{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "erfa";
  version = "1.7.1";

  buildInputs = [ autoreconfHook ];

  src = fetchFromGitHub {
    owner = "liberfa";
    repo = "erfa";
    rev = "v${version}";
    sha256 = "0j7v9y7jsw9vjmhdpksq44ah2af10b9gl1vfm8riw178lvf246wg";
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
