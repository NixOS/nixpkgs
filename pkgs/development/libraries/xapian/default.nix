{ lib, stdenv, fetchurl, autoreconfHook
, libuuid, zlib }:

let
  generic = version: hash: stdenv.mkDerivation {
    pname = "xapian";
    inherit version;
    passthru = { inherit version; };

    src = fetchurl {
      url = "https://oligarchy.co.uk/xapian/${version}/xapian-core-${version}.tar.xz";
      inherit hash;
    };

    outputs = [ "out" "man" "doc" ];

    buildInputs = [ libuuid zlib ];
    nativeBuildInputs = [ autoreconfHook ];

    doCheck = true;
    AUTOMATED_TESTING = true; # https://trac.xapian.org/changeset/8be35f5e1/git

    patches = lib.optionals stdenv.isDarwin [ ./skip-flaky-darwin-test.patch ];

    # the configure script thinks that Darwin has ___exp10
    # but it’s not available on my systems (or hydra apparently)
    postConfigure = lib.optionalString stdenv.isDarwin ''
      substituteInPlace config.h \
        --replace "#define HAVE___EXP10 1" "#undef HAVE___EXP10"
    '';

    meta = with lib; {
      description = "Search engine library";
      homepage = "https://xapian.org/";
      license = licenses.gpl2Plus;
      maintainers = with maintainers; [ ];
      platforms = platforms.unix;
    };
  };
in {
  # Don't forget to change the hashes in xapian-omega and
  # python3Packages.xapian. They inherit the version from this package, and
  # should always be built with the equivalent xapian version.
  xapian_1_4 = generic "1.4.20" "sha256-zivl7/cgdcgQbANA5wsQk9vOviq0LcHBvgjdOtQZRC0=";
}
