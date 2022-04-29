{ lib, stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libmd";
  version = "1.0.4";

  src = fetchurl {
    url = "https://archive.hadrons.org/software/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-9RySEELjS+3e3tS3VVdlZVnPWx8kSAM7TB7sEcB+Uw8=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    homepage = "https://www.hadrons.org/software/${pname}/";
    changelog = "https://archive.hadrons.org/software/libmd/libmd-${version}.announce";
    # Git: https://git.hadrons.org/cgit/libmd.git
    description = "Message Digest functions from BSD systems";
    license = with licenses; [ bsd3 bsd2 isc beerware publicDomain ];
    maintainers = with maintainers; [ primeos ];
    platforms = platforms.linux;
  };
}
