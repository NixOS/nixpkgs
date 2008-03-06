args:
args.stdenv.mkDerivation {
  name = "flapjax-source-20070514";

  src = args.fetchurl {
    url = http://www.flapjax-lang.org/download/20070514/flapjax-source.tar.gz;
    sha256 = "188dafpggbfdyciqhrjaq12q0q01z1rp3mpm2iixb0mvrci14flc";
  };

  phases = "unpackPhase buildPhase";

  buildPhase  = "
    ensureDir \$out/bin
    cd compiler;
    ghc --make Fjc.hs -o \$out/bin/fjc
  ";

  buildInputs =(with args; [ghc] ++ libs);

  meta = { 
      description = "programming language designed around the demands of modern, client-based Web applications";
      homepage = http://www.flapjax-lang.org/;
      license = "BSD";
  };
}
