{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "${package-name}-${version}";
  package-name = "paper-icon-theme";
  version = "2017-11-20";

  src = fetchFromGitHub {
    owner = "snwh";
    repo = package-name;
    rev = "af0296ecc872ad723fad7dca6e7e89eb85cbb3a8";
    sha256 = "18a9zl9lbw9gc3zas49w329xrps4slvkp4nv815nlnmimz8dj85m";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    description = "Modern icon theme designed around bold colours and simple geometric shapes";
    homepage = https://snwh.org/paper;
    license = with licenses; [ cc-by-sa-40 lgpl3 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ romildo ];
  };
}
