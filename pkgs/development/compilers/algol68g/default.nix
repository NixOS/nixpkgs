{ lib
, stdenv
, fetchurl
, gsl
, plotutils
, postgresql
}:

stdenv.mkDerivation rec {
  pname = "algol68g";
  version = "2.8.4";

  src = fetchurl {
    url = "https://jmvdveer.home.xs4all.nl/${pname}-${version}.tar.gz";
    hash = "sha256-WCPM0MGP4Qo2ihF8w5JHSMSl0P6N/w2dgY/3PDQlZfA=";
  };

  patches = [
    # add PNG support
    ./0001-plotutils-png-support.diff
  ];

  buildInputs = [
    gsl
    plotutils
    postgresql
  ];

  postInstall = let
    pdfdoc = fetchurl {
      url = "https://jmvdveer.home.xs4all.nl/learning-algol-68-genie.pdf";
      hash = "sha256-QCwn1e/lVfTYTeolCFErvfMhvwCgsBnASqq2K+NYmlU=";
    };
  in
    ''
      install -m644 ${pdfdoc} $out/share/doc/${pname}/learning-algol-68-genie.pdf
    '';

  meta = with lib; {
    homepage = "https://jmvdveer.home.xs4all.nl/en.algol-68-genie.html";
    description = "Algol 68 Genie compiler-interpreter";
    longDescription = ''
      Algol 68 Genie (a68g) is a recent checkout hybrid compiler-interpreter,
      written from scratch by Marcel van der Veer. It ranks among the most
      complete Algol 68 implementations. It implements for example arbitrary
      precision arithmetic, complex numbers, parallel processing, partial
      parametrisation and formatted transput, as well as support for curses,
      regular expressions and sounds. It can be linked to GNU plotutils, the GNU
      scientific library and PostgreSQL.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    mainProgram = "a68g";
    platforms = platforms.unix;
  };
}
