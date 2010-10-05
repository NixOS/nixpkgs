{stdenv, fetchurl, unicodeSupport ? false, cplusplusSupport ? true}:

stdenv.mkDerivation {
  name = "pcre-8.10";

  src = fetchurl {
    url = mirror://sourceforge/pcre/pcre-8.10.tar.bz2;
    sha256 = "7ac4e016f6bad8c7d990e6de9bce58c04ff5dd8838be0c5ada0afad1d6a07480";
  };

  # The compiler on Darwin crashes with an internal error while building the
  # C++ interface. Disabling optimizations on that platform remedies the
  # problem. In case we ever update the Darwin GCC version, the exception for
  # that platform ought to be removed.
  configureFlags = ''
    CPPFLAGS=-NDEBUG CFLAGS=-O3 CXXFLAGS=${if stdenv.isDarwin then "-O0" else "-O3"}
    ${if unicodeSupport then "--enable-unicode-properties" else ""}
    ${if !cplusplusSupport then "--disable-cpp" else ""}
  '';

  doCheck = true;

  meta = {
    homepage = "http://www.pcre.org/";
    description = "A library for Perl Compatible Regular Expressions";
    license = "BSD-3";

    longDescription = ''
      The PCRE library is a set of functions that implement regular
      expression pattern matching using the same syntax and semantics as
      Perl 5. PCRE has its own native API, as well as a set of wrapper
      functions that correspond to the POSIX regular expression API. The
      PCRE library is free, even for building proprietary software.
    '';

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
