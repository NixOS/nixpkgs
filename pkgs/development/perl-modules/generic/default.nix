{ lib, stdenv, perl }:

{ nativeBuildInputs ? [], name, ... } @ attrs:

stdenv.mkDerivation (
  (
  lib.recursiveUpdate
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

    # current directory (".") is removed from @INC in Perl 5.26 but many old libs rely on it
    # https://metacpan.org/pod/release/XSAWYERX/perl-5.26.0/pod/perldelta.pod#Removal-of-the-current-directory-%28%22.%22%29-from-@INC
    PERL_USE_UNSAFE_INC = lib.optionalString (lib.versionAtLeast (lib.getVersion perl) "5.26") "1";

    meta.homepage = "https://metacpan.org/release/${(builtins.parseDrvName name).name}";
  }
  attrs
  )
  //
  {
    name = "perl${lib.getVersion perl}-${name}";
    builder = ./builder.sh;
    nativeBuildInputs = nativeBuildInputs ++ [ (perl.dev or perl) ];
    inherit perl;
  }
)
