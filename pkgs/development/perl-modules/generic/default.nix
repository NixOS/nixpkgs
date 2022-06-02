{ lib, stdenv, perl, buildPerl, toPerlModule }:

{ buildInputs ? []
, nativeBuildInputs ? []
, outputs ? [ "out" "devdoc" ]
, src ? null

, doCheck ? true
, checkTarget ? "test"

# Prevent CPAN downloads.
, PERL_AUTOINSTALL ? "--skipdeps"

# From http://wiki.cpantesters.org/wiki/CPANAuthorNotes: "allows
# authors to skip certain tests (or include certain tests) when
# the results are not being monitored by a human being."
, AUTOMATED_TESTING ? true

# current directory (".") is removed from @INC in Perl 5.26 but many old libs rely on it
# https://metacpan.org/pod/release/XSAWYERX/perl-5.26.0/pod/perldelta.pod#Removal-of-the-current-directory-%28%22.%22%29-from-@INC
, PERL_USE_UNSAFE_INC ? "1"

, ...
}@attrs:

assert attrs?pname -> attrs?version;
assert attrs?pname -> !(attrs?name);

lib.warnIf (attrs ? name) "builtPerlPackage: `name' (\"${attrs.name}\") is deprecated, use `pname' and `version' instead"

(let
  defaultMeta = {
    homepage = "https://metacpan.org/release/${lib.getName attrs}"; # TODO: phase-out `attrs.name`
    platforms = perl.meta.platforms;
  };

  cleanedAttrs = builtins.removeAttrs attrs [
    "meta" "builder" "version" "pname" "fullperl"
    "buildInputs" "nativeBuildInputs" "buildInputs"
    "PERL_AUTOINSTALL" "AUTOMATED_TESTING" "PERL_USE_UNSAFE_INC"
    ];

  package = stdenv.mkDerivation ({
    pname = "perl${perl.version}-${lib.getName attrs}"; # TODO: phase-out `attrs.name`
    version = lib.getVersion attrs;                     # TODO: phase-out `attrs.name`

    builder = ./builder.sh;

    buildInputs = buildInputs ++ [ perl ];
    nativeBuildInputs = nativeBuildInputs ++ [ (perl.mini or perl) ];

    fullperl = buildPerl;

    inherit outputs src doCheck checkTarget;
    inherit PERL_AUTOINSTALL AUTOMATED_TESTING PERL_USE_UNSAFE_INC;

    meta = defaultMeta // (attrs.meta or { });
  } // cleanedAttrs);

in toPerlModule package)
