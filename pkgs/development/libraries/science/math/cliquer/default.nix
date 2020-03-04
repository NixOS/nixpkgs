{ stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  version = "1.21";
  pname = "cliquer";

  # autotoolized version of the original cliquer
  src = fetchFromGitHub {
    owner = "dimpase";
    repo = "autocliquer";
    rev = "v${version}";
    sha256 = "180i4qj1a25qfp75ig2d3144xfpb1dgcgpha0iqqghd7di4awg7z";
  };

  doCheck = true;

  buildInputs = [
    autoreconfHook
  ];

  meta = with stdenv.lib; {
    homepage = https://users.aalto.fi/~pat/cliquer.html;
    downloadPage = src.meta.homepage; # autocliquer
    description = "Routines for clique searching";
    longDescription = ''
      Cliquer is a set of C routines for finding cliques in an arbitrary weighted graph.
      It uses an exact branch-and-bound algorithm developed by Patric Östergård.
      It is designed with the aim of being efficient while still being flexible and
      easy to use.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ timokau ];
    platforms = platforms.unix;
  };
}
