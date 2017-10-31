{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "iana-etc-${version}";
  version = "20170512";

  src = fetchurl {
    url = "https://github.com/Mic92/iana-etc/releases/download/${version}/iana-etc-${version}.tar.gz";
    sha256 = "0zx2ag894qldvrv8f4hs84644kdcp8a83gjg33xsw8rrn38gll2a";
  };

  installPhase = ''
    mkdir -p $out/etc
    cp services protocols $out/etc/
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/Mic92/iana-etc;
    description = "IANA protocol and port number assignments (/etc/protocols and /etc/services)";
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
