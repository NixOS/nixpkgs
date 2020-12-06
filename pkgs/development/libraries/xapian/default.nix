{ stdenv, fetchurl, autoreconfHook
, libuuid, zlib }:

let
  generic = version: sha256: stdenv.mkDerivation {
    pname = "xapian";
    inherit version;
    passthru = { inherit version; };

    src = fetchurl {
      url = "https://oligarchy.co.uk/xapian/${version}/xapian-core-${version}.tar.xz";
      inherit sha256;
    };

    outputs = [ "out" "man" "doc" ];

    buildInputs = [ libuuid zlib ];
    nativeBuildInputs = [ autoreconfHook ];

    doCheck = true;
    AUTOMATED_TESTING = true; # https://trac.xapian.org/changeset/8be35f5e1/git

    patches = stdenv.lib.optionals stdenv.isDarwin [ ./skip-flaky-darwin-test.patch ];

    # the configure script thinks that Darwin has ___exp10
    # but it’s not available on my systems (or hydra apparently)
    postConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
      substituteInPlace config.h \
        --replace "#define HAVE___EXP10 1" "#undef HAVE___EXP10"
    '';

    meta = with stdenv.lib; {
      description = "Search engine library";
      homepage = "https://xapian.org/";
      license = licenses.gpl2Plus;
      maintainers = with maintainers; [ ];
      platforms = platforms.unix;
    };
  };
in {
  xapian_1_4 = generic "1.4.17" "0bjpaavdckl4viznr8gbq476fvg648sj4rks2vacmc51vrb8bsxm";
}
