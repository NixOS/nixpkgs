{ lib, stdenv, fetchurl, fetchpatch, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libmd";
  version = "1.0.4";

  src = fetchurl {
    urls = [
      "https://archive.hadrons.org/software/libmd/libmd-${version}.tar.xz"
      "https://libbsd.freedesktop.org/releases/libmd-${version}.tar.xz"
    ];
    sha256 = "sha256-9RySEELjS+3e3tS3VVdlZVnPWx8kSAM7TB7sEcB+Uw8=";
  };

  patches = [
    # Drop aliases for SHA384 functions, because such aliases are not supported on Darwin.
    (fetchpatch {
      url = "https://github.com/macports/macports-ports/raw/8332f5dbcaf05a02bc31fbd4ccf735e7d5c9a5b0/devel/libmd/files/patch-symbol-alias.diff";
      sha256 = "sha256-py5hMpKYKwtBzhWn01lFc2a6+OZN72YCYXyhg1qe6rg=";
      extraPrefix = "";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    homepage = "https://www.hadrons.org/software/${pname}/";
    changelog = "https://archive.hadrons.org/software/libmd/libmd-${version}.announce";
    # Git: https://git.hadrons.org/cgit/libmd.git
    description = "Message Digest functions from BSD systems";
    license = with licenses; [ bsd3 bsd2 isc beerware publicDomain ];
    maintainers = with maintainers; [ primeos ];
    platforms = platforms.unix;
  };
}
