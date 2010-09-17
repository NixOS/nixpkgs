{stdenv, fetchurl}:
stdenv.mkDerivation rec {
  version = "3.3.0";
  src = fetchurl {
    url = "mirror://gnu/osip/libosip2-${version}.tar.gz";
    sha256 = "08gqll8c7y9hzzs80cal7paxn6knnhbfkvzdaxs2sssrmbg2hpnl";
  };
  name = "libosip2-${version}";
      
  meta = {
    license = "LGPLv2.1+";
    description = "GNU oSIP library ";
    maintainers = with stdenv.lib.maintainers;
    [
      raskin
    ];
    platforms = with stdenv.lib.platforms;
      linux;
  };
}
