{ lib
, stdenv
, fetchurl
, autoreconfHook
, libuuid
, zlib

# tests
, mu
, perlPackages
, python3
, xapian-omega
}:

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

    enableParallelBuilding = true;

    doCheck = true;

    env = {
      AUTOMATED_TESTING = true; # https://trac.xapian.org/changeset/8be35f5e1/git
    } // lib.optionalAttrs stdenv.hostPlatform.is32bit {
      NIX_CFLAGS_COMPILE = "-fpermissive";
    };

    # the configure script thinks that Darwin has ___exp10
    # but it’s not available on my systems (or hydra apparently)
    postConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace config.h \
        --replace "#define HAVE___EXP10 1" "#undef HAVE___EXP10"
    '';

    passthru.tests = {
      inherit mu xapian-omega;
      inherit (perlPackages) SearchXapian;
      python-xapian = python3.pkgs.xapian;
    };

    meta = with lib; {
      description = "Search engine library";
      homepage = "https://xapian.org/";
      changelog = "https://xapian.org/docs/xapian-core-${version}/NEWS";
      license = licenses.gpl2Plus;
      maintainers = with maintainers; [ matthiasbeyer ];
      platforms = platforms.unix;
    };
  };
in {
  # Don't forget to change the hashes in xapian-omega and
  # python3Packages.xapian. They inherit the version from this package, and
  # should always be built with the equivalent xapian version.
  xapian_1_4 = generic "1.4.26" "sha256-nmp5A4BpZtFs4iC0k3fJyPrWZ8jw/8sjo0QpRiaTY6c=";
}
