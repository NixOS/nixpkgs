{ lib, stdenv, fetchurl, cmake, pkg-config, darwin }:

stdenv.mkDerivation rec {
  pname = "libdiscid";
  version = "0.6.3";

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.IOKit ];

  src = fetchurl {
    url = "http://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/${pname}-${version}.tar.gz";
    sha256 = "sha256-D578erZfJNpXZzVHMEsBQ+6J8zY4vq3MIKhAHgd7PCU=";
  };

  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-framework CoreFoundation -framework IOKit";

  meta = with lib; {
    description = "A C library for creating MusicBrainz DiscIDs from audio CDs";
    homepage = "http://musicbrainz.org/doc/libdiscid";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
