{ stdenv, fetchurl, unicodeSupport ? true
, windows ? null
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "pcre2-10.20";

  src = fetchurl {
    url = "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/${name}.tar.bz2";
    sha256 = "0yj8mm9ll9zj3v47rvmmqmr1ybxk72rr2lym3rymdsf905qjhbik";
  };

  configureFlags = [ "--enable-jit" ]
                ++ stdenv.lib.optional unicodeSupport "--enable-unicode";

  doCheck = with stdenv; !(isCygwin || isFreeBSD);
    # XXX: test failure on Cygwin
    # we are running out of stack on both freeBSDs on Hydra

  crossAttrs = optionalAttrs (stdenv.cross.libc == "msvcrt") {
    buildInputs = [ windows.mingw_w64_pthreads.crossDrv ];
  };

  meta = {
    homepage = "http://www.pcre.org/";
    description = "A library for Perl Compatible Regular Expressions";
    license = stdenv.lib.licenses.bsd3;

    longDescription = ''
      The PCRE library is a set of functions that implement regular
      expression pattern matching using the same syntax and semantics as
      Perl 5. PCRE has its own native API, as well as a set of wrapper
      functions that correspond to the POSIX regular expression API. The
      PCRE library is free, even for building proprietary software.
    '';

    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
  };
}
