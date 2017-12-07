{ stdenv, fetchurl
, pcre, windows ? null
, buildPlatform, hostPlatform
, variant ? null
}:

with stdenv.lib;

assert elem variant [ null "cpp" "pcre16" "pcre32" ];

let
  version = "8.40";
  pname = if (variant == null) then "pcre"
    else  if (variant == "cpp") then "pcre-cpp"
    else  variant;

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-${version}.tar.bz2";
    sha256 = "1x7lpjn7jhk0n3sdvggxrlrhab8kkfjwl7qix0ypw9nlx8lpmqh0";
  };

  outputs = [ "bin" "dev" "out" "doc" "man" ];

  configureFlags = [
    "--enable-jit"
    "--enable-unicode-properties"
    "--disable-cpp"
  ]
    ++ optional (variant != null) "--enable-${variant}";

  patches = [ ./CVE-2017-7186.patch ];

  buildInputs = optional (hostPlatform.libc == "msvcrt") windows.mingw_w64_pthreads;

  doCheck = !(with hostPlatform; isCygwin || isFreeBSD) && hostPlatform == buildPlatform;
    # XXX: test failure on Cygwin
    # we are running out of stack on both freeBSDs on Hydra

  postFixup = ''
    moveToOutput bin/pcre-config "$dev"
  ''
    + optionalString (variant != null) ''
    ln -sf -t "$out/lib/" '${pcre.out}'/lib/libpcre{,posix}.{so.*.*.*,*dylib}
  '';

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
  };
}
