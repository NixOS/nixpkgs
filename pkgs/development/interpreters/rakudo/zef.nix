{ stdenv, fetchFromGitHub, rakudo, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "zef";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "ugexe";
    repo = "zef";
    rev = "v${version}";
    sha256 = "1fscv8fbaa5l8dcwclmq3hvg3c59l4dvyjqb316mgnc5anxpzy2f";
  };

  buildInputs = [ rakudo makeWrapper ];

  installPhase = ''
    mkdir -p "$out"
    # TODO: Find better solution. zef stores cache stuff in $HOME with the
    # default config.
    env HOME=$TMPDIR ${rakudo}/bin/raku -I. ./bin/zef --/depends --/test-depends --/build-depends --install-to=$out install .
  '';

  postFixup =''
    wrapProgram $out/bin/zef --prefix RAKUDOLIB , "inst#$out"
  '';

  meta = with stdenv.lib; {
    description = "Raku / Perl6 Module Management";
    homepage    = "https://github.com/ugexe/zef";
    license     = licenses.artistic2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ sgo ];
  };
}
