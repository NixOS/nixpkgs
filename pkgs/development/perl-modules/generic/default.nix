{ lib, stdenv, perl, buildPerl, toPerlModule }:

{ buildInputs ? [], nativeBuildInputs ? [], ... } @ attrs:

assert attrs?pname -> attrs?version;
assert attrs?pname -> !(attrs?name);

(if attrs ? name then
  lib.trivial.warn "builtPerlPackage: `name' (\"${attrs.name}\") is deprecated, use `pname' and `version' instead"
 else
  (x: x))
toPerlModule(stdenv.mkDerivation (
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
    PERL_USE_UNSAFE_INC = "1";

    meta.homepage = "https://metacpan.org/release/${lib.getName attrs}"; # TODO: phase-out `attrs.name`
    meta.platforms = perl.meta.platforms;
  }
  attrs
  )
  //
  {
    pname = "perl${perl.version}-${lib.getName attrs}"; # TODO: phase-out `attrs.name`
    version = lib.getVersion attrs;                     # TODO: phase-out `attrs.name`
    builder = ./builder.sh;
    buildInputs = buildInputs ++ [ perl ];
    nativeBuildInputs = nativeBuildInputs ++ [ (perl.dev or perl) ];
    fullperl = buildPerl;
  }
))
