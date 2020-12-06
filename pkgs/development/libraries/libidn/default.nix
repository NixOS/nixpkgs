{ fetchurl, stdenv, libiconv }:

stdenv.mkDerivation rec {
  name = "libidn-1.36";

  src = fetchurl {
    url = "mirror://gnu/libidn/${name}.tar.gz";
    sha256 = "0f20n634whpmdwr81c2r0vxxjwchgkvhsr1i8s2bm0ad6h473dhl";
  };

  outputs = [ "bin" "dev" "out" "info" "devdoc" ];

  # broken with gcc-7
  #doCheck = !stdenv.isDarwin && !stdenv.hostPlatform.isMusl;

  hardeningDisable = [ "format" ];

  buildInputs = stdenv.lib.optional stdenv.isDarwin libiconv;

  doCheck = false; # fails

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

    repositories.git = "git://git.savannah.gnu.org/libidn.git";
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ ];
  };
}
