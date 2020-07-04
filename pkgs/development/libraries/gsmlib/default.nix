{ stdenv, fetchFromGitHub, autoreconfHook }:
stdenv.mkDerivation rec {
  pname = "gsmlib";
  version = "unstable-2017-10-06";
  src = fetchFromGitHub {
    owner = "x-logLT";
    repo = "gsmlib";
    rev = "4f794b14450132f81673f7d3570c5a859aecf7ae";
    sha256 = "16v8aj914ac1ipf14a867ljib3gy7fhzd9ypxnsg9l0zi8mm3ml5";
  };
  nativeBuildInputs = [ autoreconfHook ];
  meta = with stdenv.lib; {
    description = "Library to access GSM mobile phones through GSM modems";
    homepage = "https://github.com/x-logLT/gsmlib";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.misuzu ];
  };
}
