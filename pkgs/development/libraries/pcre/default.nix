{ stdenv, lib, fetchurl, unicodeSupport ? true, cplusplusSupport ? true
, windows ? null
, withCharSize ? 8
}:

with stdenv.lib;

assert withCharSize != 8 -> !cplusplusSupport;

let
  charFlags = if withCharSize == 8 then [ ]
              else if withCharSize == 16 then [ "--enable-pcre16" "--disable-pcre8" ]
              else if withCharSize == 32 then [ "--enable-pcre32" "--disable-pcre8" ]
              else abort "Invalid character size";

in stdenv.mkDerivation rec {
  name = "pcre${lib.optionalString (withCharSize != 8) (toString withCharSize)}-${version}";
  version = "8.38";

  src = fetchurl {
    url = "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-${version}.tar.bz2";
    sha256 = "1pvra19ljkr5ky35y2iywjnsckrs9ch2anrf5b0dc91hw8v2vq5r";
  };

  patches = [
    ./CVE-2016-1283.patch
  ];

  outputs = [ "out" "doc" "man" ];

  configureFlags =
    [ "--enable-jit" ]
    ++ lib.optional unicodeSupport "--enable-unicode-properties"
    ++ lib.optional (!cplusplusSupport) "--disable-cpp"
    ++ charFlags;

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
    maintainers = [ maintainers.simons ];
  };
}
