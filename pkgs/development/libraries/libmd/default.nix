{ lib, stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libmd";
  version = "1.0.3";

  src = fetchurl {
    url = "https://archive.hadrons.org/software/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0jmga8y94h857ilra3qjaiax3wd5pd6mx1h120zhl9fcjmzhj0js";
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
