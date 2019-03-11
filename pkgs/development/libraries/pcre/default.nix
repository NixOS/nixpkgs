{ stdenv, fetchurl
, pcre, windows ? null
, variant ? null
}:

with stdenv.lib;

assert elem variant [ null "cpp" "pcre16" "pcre32" ];

let
  version = "8.43";
  pname = if (variant == null) then "pcre"
    else  if (variant == "cpp") then "pcre-cpp"
    else  variant;

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://ftp.pcre.org/pub/pcre/pcre-${version}.tar.bz2";
    sha256 = "0sxg1wlknq05ryq63h21cchjmcjkin9lmnqsmhs3h08301965rwi";
  };

  outputs = [ "bin" "dev" "out" "doc" "man" ];

  configureFlags = optional (!stdenv.hostPlatform.isRiscV) "--enable-jit" ++ [
    "--enable-unicode-properties"
    "--disable-cpp"
  ]
    ++ optional (variant != null) "--enable-${variant}";

  buildInputs = optional (stdenv.hostPlatform.libc == "msvcrt") windows.mingw_w64_pthreads;

  # https://bugs.exim.org/show_bug.cgi?id=2173
  patches = [ ./stacksize-detection.patch ];

  preCheck = ''
    patchShebangs RunGrepTest
  '';

  doCheck = !(with stdenv.hostPlatform; isCygwin || isFreeBSD) && stdenv.hostPlatform == stdenv.buildPlatform;
    # XXX: test failure on Cygwin
    # we are running out of stack on both freeBSDs on Hydra

  postFixup = ''
    moveToOutput bin/pcre-config "$dev"
  ''
    + optionalString (variant != null) ''
    ln -sf -t "$out/lib/" '${pcre.out}'/lib/libpcre{,posix}.{so.*.*.*,*dylib}
  '';

  meta = {
    homepage = http://www.pcre.org/;
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
