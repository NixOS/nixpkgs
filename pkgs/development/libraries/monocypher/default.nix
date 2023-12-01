{ lib, stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "monocypher";
  version = "4.0.2";

  src = fetchurl {
    url = "https://monocypher.org/download/monocypher-${version}.tar.gz";
    hash = "sha256-ONBxeXOMDJBnfbo863p7hJa8/qdYuhpT6AP+0wrgh5w=";
  };

  installFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  meta = with lib; {
    description = "Boring crypto that simply works";
    homepage = "https://monocypher.org";
    license = with licenses; [ bsd2 cc0 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ sikmir ];
  };
}
