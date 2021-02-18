{ stdenv, fetchFromGitHub, fetchpatch
, autoconf
, automake
, libtool
, openssl
}:

stdenv.mkDerivation rec {
  pname = "libetpan";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "dinhviethoa";
    repo = "libetpan";
    rev = version;
    sha256 = "19g4qskg71jv7sxfxsdkjmrxk9mk5kf9b6fhw06g6wvm3205n95f";
  };

  nativeBuildInputs = [ libtool autoconf automake ];

  patches = [
    # The following two patches are fixing CVE-2020-15953, as reported in the
    # issue tracker: https://github.com/dinhvh/libetpan/issues/386
    # They might be removed for the next version bump.

    # CVE-2020-15953: Detect extra data after STARTTLS response and exit
    # https://github.com/dinhvh/libetpan/pull/387
    (fetchpatch {
      name = "cve-2020-15953-imap.patch";
      url = "https://github.com/dinhvh/libetpan/commit/1002a0121a8f5a9aee25357769807f2c519fa50b.patch";
      sha256 = "1h9ds2z4jii40a0i3z6hsnzx1ldmd2jqidsxp2y2ksyp1ijcgabn";
    })

    # CVE-2020-15953: Detect extra data after STARTTLS responses in SMTP and POP3 and exit
    # https://github.com/dinhvh/libetpan/pull/388
    (fetchpatch {
      name = "cve-2020-15953-pop3-smtp.patch";
      url = "https://github.com/dinhvh/libetpan/commit/298460a2adaabd2f28f417a0f106cb3b68d27df9.patch";
      sha256 = "0lq829djar7nb3fai3vdzirmks3w2lfagzqc809lx2lln6y213a0";
    })
  ];

  buildInputs = [ openssl ];

  configureScript = "./autogen.sh";

  meta = with stdenv.lib; {
    description = "An efficient, portable library for different kinds of mail access: IMAP, SMTP, POP, and NNTP";
    homepage = "http://www.etpan.org/libetpan.html";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
