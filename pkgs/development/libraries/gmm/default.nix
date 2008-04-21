args:
args.stdenv.mkDerivation {
  name = "gmm-3.0";

  src = args.fetchurl {
    url = http://download.gna.org/getfem/stable/gmm-3.0.tar.gz;
    sha256 = "1lc34w68s0rhii6caklvq2pyc3jaa4g6kza948ya8ha6rr8d1ypp";
  };

  buildInputs =(with args; []);

  meta = { 
      description = "generic C++ template library for sparse, dense and skyline matrices";
      homepage = http://home.gna.org/getfem/gmm_intro.html;
      license = "LGLP2.1"; # or later
  };
}
