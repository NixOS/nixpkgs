{ stdenv, fetchurl, autoreconfHook
, libuuid, zlib }:

let
  generic = version: sha256: stdenv.mkDerivation rec {
    name = "xapian-${version}";
    passthru = { inherit version; };

    src = fetchurl {
      url = "https://oligarchy.co.uk/xapian/${version}/xapian-core-${version}.tar.xz";
      inherit sha256;
    };

    patches = stdenv.lib.optional (version == "1.4.7") [
      # fix notmuch build, see https://notmuchmail.org/faq/#index12h2
      # cannot fetchpatch this because base directory differs
      # TODO: remove on next xapian update
      ./fix-notmuch-tagging.patch
    ];

    outputs = [ "out" "man" "doc" ];

    buildInputs = [ libuuid zlib ];
    nativeBuildInputs = [ autoreconfHook ];

    doCheck = true;

    # the configure script thinks that Darwin has ___exp10
    # but it’s not available on my systems (or hydra apparently)
    postConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
      substituteInPlace config.h \
        --replace "#define HAVE___EXP10 1" "#undef HAVE___EXP10"
    '';

    meta = with stdenv.lib; {
      description = "Search engine library";
      homepage = https://xapian.org/;
      license = licenses.gpl2Plus;
      maintainers = with maintainers; [ chaoflow ];
      platforms = platforms.unix;
    };
  };
in {
  # xapian-ruby needs 1.2.22 as of 2017-05-06
  xapian_1_2_22 = generic "1.2.22" "0zsji22n0s7cdnbgj0kpil05a6bgm5cfv0mvx12d8ydg7z58g6r6";
  xapian_1_4 = generic "1.4.7" "1lxmlds3v5s1gng9nk1rvmln1zcksrw5ds509y0glylwch5qmw0k";
}
