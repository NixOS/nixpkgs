args:
args.stdenv.mkDerivation {
  name = "gsl-1.9";

  src = args.fetchurl {
    url = ftp://ftp.gnu.org/gnu/gsl/gsl-1.9.tar.gz;
    sha256 = "0l12js65c1qf3s7gmgay6gj5nbs6635py41dj8nk3hlp95wcdlgw";
  };

  buildInputs =(with args; []);

  meta = { 
      description = "numerical library (>1000 functions)";
      homepage = http://www.gnu.org/software/gsl;
      license = "GPL2";
  };
}
