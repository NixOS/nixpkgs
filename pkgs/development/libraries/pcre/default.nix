{ stdenv, fetchurl
, windows ? null, variant ? null, pcre
}:

with stdenv.lib;

assert elem variant [ null "cpp" "pcre16" "pcre32" ];

let
  version = "8.39";
  pname = if (variant == null) then "pcre"
    else  if (variant == "cpp") then "pcre-cpp"
    else  variant;

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-${version}.tar.bz2";
    sha256 = "12wyajlqx2v7dsh39ra9v9m5hibjkrl129q90bp32c28haghjn5q";
  };

  outputs = [ "bin" "dev" "out" "doc" "man" ];

  configureFlags = [
    "--enable-jit"
    "--enable-unicode-properties"
    "--disable-cpp"
  ]
    ++ optional (variant != null) "--enable-${variant}";

  doCheck = with stdenv; !(isCygwin || isFreeBSD);
    # XXX: test failure on Cygwin
    # we are running out of stack on both freeBSDs on Hydra

  postFixup = ''
    moveToOutput bin/pcre-config "$dev"
  ''
    + optionalString (variant != null) ''
    ln -sf -t "$out/lib/" '${pcre.out}'/lib/libpcre{,posix}.{so.*.*.*,*dylib}
  '';

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
  };
}
