{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "libiconv-1.14";

  src = fetchurl {
    url = "mirror://gnu/libiconv/${name}.tar.gz";
    sha256 = "04q6lgl3kglmmhw59igq1n7v3rp1rpkypl366cy1k1yn2znlvckj";
  };

  # On Cygwin, Libtool produces a `.dll.a', which is not a "real" DLL
  # (Windows' linker would need to be used somehow to produce an actual
  # DLL.)  Thus, build the static library too, and this is what Gettext
  # will actually use.
  configureFlags = stdenv.lib.optional stdenv.isCygwin [ "--enable-static" ];

  crossAttrs = {
    # Disable stripping to avoid "libiconv.a: Archive has no index" (MinGW).
    dontStrip = true;
    dontCrossStrip = true;
  };

  meta = {
    description = "An iconv(3) implementation";

    longDescription = ''
      Some programs, like mailers and web browsers, must be able to convert
      between a given text encoding and the user's encoding.  Other programs
      internally store strings in Unicode, to facilitate internal processing,
      and need to convert between internal string representation (Unicode)
      and external string representation (a traditional encoding) when they
      are doing I/O.  GNU libiconv is a conversion library for both kinds of
      applications.
    '';

    homepage = http://www.gnu.org/software/libiconv/;
    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = [ ];

    # This library is not needed on GNU platforms.
    hydraPlatforms = stdenv.lib.platforms.cygwin ++ stdenv.lib.platforms.darwin ++ stdenv.lib.platforms.freebsd;
  };
}
