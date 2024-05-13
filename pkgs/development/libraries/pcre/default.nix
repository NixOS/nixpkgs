{ lib, stdenv, fetchurl, fetchpatch
, pcre, windows ? null
, variant ? null
}:

assert lib.elem variant [ null "cpp" "pcre16" "pcre32" ];

stdenv.mkDerivation rec {
  pname = "pcre"
    + lib.optionalString (variant == "cpp") "-cpp"
    + lib.optionalString (variant != "cpp" && variant != null) variant;
  version = "8.45";

  src = fetchurl {
    url = "mirror://sourceforge/project/pcre/pcre/${version}/pcre-${version}.tar.bz2";
    sha256 = "sha256-Ta5v3NK7C7bDe1+Xwzwr6VTadDmFNpzdrDVG4yGL/7g=";
  };

  outputs = [ "bin" "dev" "out" "doc" "man" ];

  # Disable jit on Apple Silicon, https://github.com/zherczeg/sljit/issues/51
  configureFlags = lib.optional (!(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64)) "--enable-jit=auto" ++ [
    "--enable-unicode-properties"
    "--disable-cpp"
  ]
    ++ lib.optional (variant != null) "--enable-${variant}";

  patches = [
    # https://bugs.exim.org/show_bug.cgi?id=2173
    ./stacksize-detection.patch

    # Fix segfaults & tests on powerpc64
    (fetchpatch {
      name = "sljit-ppc-icache-flush.patch";
      url = "https://github.com/void-linux/void-packages/raw/d286e231ee680875ad8e80f90ea62e46f5edd812/srcpkgs/pcre/patches/ppc-icache-flush.patch";
      hash = "sha256-pttmKwihLzKrAV6O4qVLp2pu4NwNJEFS/9Id8/b3nAU=";
    })
  ];

  preCheck = ''
    patchShebangs RunGrepTest
  '';

  doCheck = !(with stdenv.hostPlatform; isCygwin || isFreeBSD) && stdenv.hostPlatform == stdenv.buildPlatform;
    # XXX: test failure on Cygwin
    # we are running out of stack on both freeBSDs on Hydra

  postFixup = ''
    moveToOutput bin/pcre-config "$dev"
  '' + lib.optionalString (variant != null) ''
    ln -sf -t "$out/lib/" '${pcre.out}'/lib/libpcre{,posix}.{so.*.*.*,*dylib,*a}
  '';

  meta = {
    homepage = "http://www.pcre.org/";
    description = "A library for Perl Compatible Regular Expressions";
    license = lib.licenses.bsd3;

    longDescription = ''
      The PCRE library is a set of functions that implement regular
      expression pattern matching using the same syntax and semantics as
      Perl 5. PCRE has its own native API, as well as a set of wrapper
      functions that correspond to the POSIX regular expression API. The
      PCRE library is free, even for building proprietary software.
    '';

    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ];
    pkgConfigModules = [
      "libpcre"
      "libpcreposix"
    ];
  };
}
