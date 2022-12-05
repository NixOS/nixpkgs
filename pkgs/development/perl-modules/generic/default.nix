{ lib, stdenv, perl, toPerlModule }:

{ buildInputs ? []
, nativeBuildInputs ? []
, outputs ? [ "out" "devdoc" ]
, src ? null

# enabling or disabling does nothing for perl packages so set it explicitly
# to false to not change hashes when enableParallelBuildingByDefault is enabled
, enableParallelBuilding ? false

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

lib.throwIf (attrs ? name) "buildPerlPackage: `name` (\"${attrs.name}\") is deprecated, use `pname` and `version` instead"

(let
  defaultMeta = {
    homepage = "https://metacpan.org/dist/${attrs.pname}";
    inherit (perl.meta) platforms;
  };

  package = stdenv.mkDerivation (attrs // {
    name = "perl${perl.version}-${attrs.pname}-${attrs.version}";

    builder = ./builder.sh;

    buildInputs = buildInputs ++ [ perl ];
    nativeBuildInputs = nativeBuildInputs ++ [ (perl.__spliced.buildHost.mini or perl) ];

    fullperl = perl.__spliced.buildHost or perl;

    inherit outputs src doCheck checkTarget enableParallelBuilding;
    inherit PERL_AUTOINSTALL AUTOMATED_TESTING PERL_USE_UNSAFE_INC;

    meta = defaultMeta // (attrs.meta or { });
  });

in toPerlModule package)
