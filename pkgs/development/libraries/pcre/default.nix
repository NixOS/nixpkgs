{ stdenv, fetchurl
, pcre, windows ? null
, buildPlatform, hostPlatform
, variant ? null
}:

with stdenv.lib;

assert elem variant [ null "cpp" "pcre16" "pcre32" ];

let
  version = "8.42";
  pname = if (variant == null) then "pcre"
    else  if (variant == "cpp") then "pcre-cpp"
    else  variant;

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://ftp.pcre.org/pub/pcre/pcre-${version}.tar.bz2";
    sha256 = "00ckpzlgyr16bnqx8fawa3afjgqxw5yxgs2l081vw23qi1y4pl1c";
  };

  outputs = [ "bin" "dev" "out" "doc" "man" ];

  configureFlags = optional (!hostPlatform.isRiscV) "--enable-jit" ++ [
    "--enable-unicode-properties"
    "--disable-cpp"
  ]
    ++ optional (variant != null) "--enable-${variant}";

  buildInputs = optional (hostPlatform.libc == "msvcrt") windows.mingw_w64_pthreads;

  # https://bugs.exim.org/show_bug.cgi?id=2173
  patches = [ ./stacksize-detection.patch ];

  preCheck = ''
    patchShebangs RunGrepTest
  '';

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
