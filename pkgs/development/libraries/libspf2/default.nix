{ lib, stdenv, fetchFromGitHub, autoreconfHook, fetchpatch }:

with lib;

stdenv.mkDerivation rec {
  pname = "libspf2";
  version = "2.2.12";

  src = fetchFromGitHub {
    owner = "helsinki-systems";
    repo = "libspf2";
    rev = "v${version}";
    sha256 = "03iiaafdcwh220pqignk407h6klrakwz0zkb8iwk6nkwipkwvhsx";
  };

  patches = [
    # glibc-2.34 compat
    (fetchpatch {
      url = "https://raw.githubusercontent.com/gentoo/gentoo/dbb8a5c9f749cc11e61cfe558f164b165cbc30cb/mail-filter/libspf2/files/libspf2-1.2.11-undefined-dn_.patch";
      sha256 = "sha256-6JVVkVGCcFJsNeBdVTPcLhW4KoHLY4ai/KXDMliXgPA=";
    })
  ];

  postPatch = ''
    # disable static bins compilation
    sed -i \
      -e '/bin_PROGRAMS/s/spfquery_static//' src/spfquery/Makefile.am \
      -e '/bin_PROGRAMS/s/spftest_static//' src/spftest/Makefile.am \
      -e '/bin_PROGRAMS/s/spfd_static//' src/spfd/Makefile.am \
      -e '/bin_PROGRAMS/s/spf_example_static//' src/spf_example/Makefile.am
  '';

  # autoreconf necessary because we modified automake files
  nativeBuildInputs = [ autoreconfHook ];

  doCheck = true;

  meta = {
    description = "Implementation of the Sender Policy Framework for SMTP " +
                  "authorization (Helsinki Systems fork)";
    homepage = "https://github.com/helsinki-systems/libspf2";
    license = with licenses; [ lgpl21Plus bsd2 ];
    maintainers = with maintainers; [ pacien ajs124 das_j ];
    platforms = platforms.all;
  };
}
