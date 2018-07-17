perl:

{ nativeBuildInputs ? [], name, ... } @ attrs:

perl.stdenv.mkDerivation (
  (
  perl.stdenv.lib.recursiveUpdate
  {
    outputs = [ "out" "devdoc" ];

    doCheck = true;

    checkTarget = "test";

    # Prevent CPAN downloads.
    PERL_AUTOINSTALL = "--skipdeps";

    # Avoid creating perllocal.pod, which contains a timestamp
    installTargets = "pure_install";

    # From http://wiki.cpantesters.org/wiki/CPANAuthorNotes: "allows
    # authors to skip certain tests (or include certain tests) when
    # the results are not being monitored by a human being."
    AUTOMATED_TESTING = true;

    meta.homepage = "https://metacpan.org/release/${(builtins.parseDrvName name).name}";
  }
  attrs
  )
  //
  {
    name = "perl-" + name;
    builder = ./builder.sh;
    nativeBuildInputs = nativeBuildInputs ++ [ (perl.dev or perl) ];
    inherit perl;
  }
)
