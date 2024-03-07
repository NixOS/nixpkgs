{ fetchurl, lib, stdenv, libiconv
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libidn";
  version = "1.41";

  src = fetchurl {
    url = "mirror://gnu/libidn/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-iE1wY2S4Gr3Re+6Whtj/KudDHFoUZRBHxorfizH9iUU=";
  };

  outputs = [ "bin" "dev" "out" "info" "devdoc" ];

  hardeningDisable = [ "format" ];

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    homepage = "https://www.gnu.org/software/libidn/";
    description = "Library for internationalized domain names";

    longDescription = ''
      GNU Libidn is a fully documented implementation of the
      Stringprep, Punycode and IDNA specifications.  Libidn's purpose
      is to encode and decode internationalized domain names.  The
      native C, C\# and Java libraries are available under the GNU
      Lesser General Public License version 2.1 or later.

      The library contains a generic Stringprep implementation.
      Profiles for Nameprep, iSCSI, SASL, XMPP and Kerberos V5 are
      included.  Punycode and ASCII Compatible Encoding (ACE) via IDNA
      are supported.  A mechanism to define Top-Level Domain (TLD)
      specific validation tables, and to compare strings against those
      tables, is included.  Default tables for some TLDs are also
      included.
    '';

    license = lib.licenses.lgpl2Plus;
    pkgConfigModules = [ "libidn" ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ lsix ];
  };
})
